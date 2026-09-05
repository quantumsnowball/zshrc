// Minimal ASN.1 DER helpers — enough to encode a CMS SignedData structure for
// a detached PKCS#7 signature and to parse a small subset of an X.509
// certificate (just issuer DN and serial number).

// ---- encoding ------------------------------------------------------------
function encodeLength(n) {
    if (n < 128) return Uint8Array.of(n);
    const bytes = [];
    let v = n;
    while (v > 0) { bytes.unshift(v & 0xff); v >>>= 8; }
    return Uint8Array.of(0x80 | bytes.length, ...bytes);
}

function concat(arrays) {
    let total = 0;
    for (const a of arrays) total += a.length;
    const out = new Uint8Array(total);
    let off = 0;
    for (const a of arrays) { out.set(a, off); off += a.length; }
    return out;
}

function tlv(tag, value) {
    const len = encodeLength(value.length);
    const out = new Uint8Array(1 + len.length + value.length);
    out[0] = tag;
    out.set(len, 1);
    out.set(value, 1 + len.length);
    return out;
}

export const SEQUENCE_TAG = 0x30;
export const SET_TAG = 0x31;
export const OCTET_STRING_TAG = 0x04;

export function sequence(...parts) { return tlv(SEQUENCE_TAG, concat(parts)); }
export function set(...parts) { return tlv(SET_TAG, concat(parts)); }
export function octetString(bytes) { return tlv(OCTET_STRING_TAG, bytes); }
export const nullValue = () => Uint8Array.of(0x05, 0x00);

// [n] EXPLICIT (context-specific, constructed)
export function explicitCtx(n, value) { return tlv(0xA0 | n, value); }
// [n] IMPLICIT SET OF (same wire form as explicit constructed, differs from OCTET STRING etc.)
export function implicitCtx(n, value) { return tlv(0xA0 | n, value); }

export function integer(n) {
    if (typeof n === 'bigint' || typeof n === 'number') {
        let v = BigInt(n);
        if (v === 0n) return Uint8Array.of(0x02, 0x01, 0x00);
        const negative = v < 0n;
        const bytes = [];
        if (!negative) {
            while (v > 0n) { bytes.unshift(Number(v & 0xffn)); v >>= 8n; }
            if (bytes[0] & 0x80) bytes.unshift(0);
        } else {
            // Two's complement encoding for negatives. We don't need this for our use cases.
            throw new Error('negative integers not supported');
        }
        return tlv(0x02, new Uint8Array(bytes));
    }
    // Already a Uint8Array containing the magnitude's bytes; enforce sign bit.
    let b = n;
    if (b.length > 0 && (b[0] & 0x80)) {
        const tmp = new Uint8Array(b.length + 1);
        tmp.set(b, 1);
        b = tmp;
    }
    return tlv(0x02, b);
}

export function oid(str) {
    const parts = str.split('.').map(Number);
    const bytes = [parts[0] * 40 + parts[1]];
    for (let i = 2; i < parts.length; i++) {
        let v = parts[i];
        const stack = [v & 0x7f];
        v >>>= 7;
        while (v > 0) { stack.unshift((v & 0x7f) | 0x80); v >>>= 7; }
        bytes.push(...stack);
    }
    return tlv(0x06, new Uint8Array(bytes));
}

// ---- parsing -------------------------------------------------------------
/**
 * Parse one DER TLV starting at `off`. Returns the tag, the value bytes,
 * the offset of the next TLV, and the full TLV bytes (useful for re-emitting
 * complex structures untouched).
 */
export function read(buf, off = 0) {
    const tag = buf[off];
    let len = buf[off + 1];
    let headerLen = 2;
    if (len & 0x80) {
        const n = len & 0x7f;
        len = 0;
        for (let i = 0; i < n; i++) len = (len << 8) | buf[off + 2 + i];
        headerLen = 2 + n;
    }
    const value = buf.subarray(off + headerLen, off + headerLen + len);
    const full = buf.subarray(off, off + headerLen + len);
    return { tag, value, full, next: off + headerLen + len };
}

/**
 * Extract the issuer Name TLV and the serialNumber integer TLV from a DER
 * certificate (tbsCertificate's first few fields).
 */
export function parseCertIssuerAndSerial(certDer) {
    // Certificate ::= SEQUENCE { tbsCertificate ... }
    const cert = read(certDer, 0);
    if (cert.tag !== SEQUENCE_TAG) throw new Error('cert: expected SEQUENCE');
    // tbsCertificate ::= SEQUENCE
    const tbs = read(cert.value, 0);
    if (tbs.tag !== SEQUENCE_TAG) throw new Error('cert: expected tbsCertificate SEQUENCE');
    let p = 0;
    // Optional [0] EXPLICIT version
    let cur = read(tbs.value, p);
    if (cur.tag === 0xA0) { p = cur.next; cur = read(tbs.value, p); }
    // serialNumber INTEGER
    if (cur.tag !== 0x02) throw new Error('cert: expected serialNumber INTEGER');
    const serial = cur.full;
    p = cur.next;
    // signature AlgorithmIdentifier SEQUENCE
    cur = read(tbs.value, p);
    p = cur.next;
    // issuer Name (SEQUENCE)
    cur = read(tbs.value, p);
    if (cur.tag !== SEQUENCE_TAG) throw new Error('cert: expected issuer SEQUENCE');
    const issuer = cur.full;
    return { issuer, serial };
}

// ---- PEM -----------------------------------------------------------------
export function pemToDer(pem, label) {
    const re = new RegExp(`-----BEGIN ${label}-----([\\s\\S]*?)-----END ${label}-----`);
    const m = pem.match(re);
    if (!m) throw new Error(`PEM: no ${label} block`);
    const b64 = m[1].replace(/\s+/g, '');
    const bin = atob(b64);
    const out = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
}
