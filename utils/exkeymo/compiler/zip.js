// Minimal ZIP (APK) reader/writer using the browser's CompressionStream API.
// Only implements what we need: read a ZIP's files (decompressed), and write a
// new ZIP with deflated entries, preserving the order in which entries are
// supplied. No Zip64, no encryption, no extra fields beyond what's in the
// source APK are carried over.

const LFH_SIG = 0x04034b50;
const CDH_SIG = 0x02014b50;
const EOCD_SIG = 0x06054b50;

const TEXT = new TextEncoder();

// --- CRC-32 ---------------------------------------------------------------
const CRC_TABLE = (() => {
    const t = new Uint32Array(256);
    for (let i = 0; i < 256; i++) {
        let c = i;
        for (let k = 0; k < 8; k++) c = (c & 1) ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1);
        t[i] = c;
    }
    return t;
})();

export function crc32(bytes) {
    let c = 0xffffffff;
    for (let i = 0; i < bytes.length; i++) {
        c = CRC_TABLE[(c ^ bytes[i]) & 0xff] ^ (c >>> 8);
    }
    return (c ^ 0xffffffff) >>> 0;
}

// --- deflate / inflate ----------------------------------------------------
async function streamTransform(data, tx) {
    const stream = new Response(data).body.pipeThrough(tx);
    const chunks = [];
    let total = 0;
    const reader = stream.getReader();
    for (;;) {
        const { done, value } = await reader.read();
        if (done) break;
        chunks.push(value);
        total += value.length;
    }
    const out = new Uint8Array(total);
    let off = 0;
    for (const c of chunks) { out.set(c, off); off += c.length; }
    return out;
}

export function deflateRaw(data) {
    return streamTransform(data, new CompressionStream('deflate-raw'));
}

export function inflateRaw(data) {
    return streamTransform(data, new DecompressionStream('deflate-raw'));
}

// --- ZIP reader -----------------------------------------------------------
/**
 * Parse a ZIP/APK buffer and return an array of { name, data } in central
 * directory order, with each entry's content already decompressed.
 * @param {Uint8Array} buf
 * @returns {Promise<Array<{name: string, data: Uint8Array}>>}
 */
export async function unzip(buf) {
    const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
    // Find the End Of Central Directory record. Scan from the end for its signature.
    let eocd = -1;
    for (let i = buf.length - 22; i >= Math.max(0, buf.length - 22 - 0xffff); i--) {
        if (dv.getUint32(i, true) === EOCD_SIG) {
            // Verify by checking that (i + 22 + commentLen) === buf.length
            const commentLen = dv.getUint16(i + 20, true);
            if (i + 22 + commentLen === buf.length) { eocd = i; break; }
        }
    }
    if (eocd < 0) throw new Error('zip: EOCD not found');

    const cdCount = dv.getUint16(eocd + 10, true);
    const cdOffset = dv.getUint32(eocd + 16, true);

    const entries = [];
    let p = cdOffset;
    for (let i = 0; i < cdCount; i++) {
        if (dv.getUint32(p, true) !== CDH_SIG) throw new Error('zip: bad CDH');
        const method = dv.getUint16(p + 10, true);
        const compSize = dv.getUint32(p + 20, true);
        const uncompSize = dv.getUint32(p + 24, true);
        const nameLen = dv.getUint16(p + 28, true);
        const extraLen = dv.getUint16(p + 30, true);
        const commentLen = dv.getUint16(p + 32, true);
        const lfhOffset = dv.getUint32(p + 42, true);
        const name = new TextDecoder().decode(buf.subarray(p + 46, p + 46 + nameLen));
        p += 46 + nameLen + extraLen + commentLen;

        if (dv.getUint32(lfhOffset, true) !== LFH_SIG) throw new Error('zip: bad LFH');
        const lNameLen = dv.getUint16(lfhOffset + 26, true);
        const lExtraLen = dv.getUint16(lfhOffset + 28, true);
        const dataOffset = lfhOffset + 30 + lNameLen + lExtraLen;
        const rawData = buf.subarray(dataOffset, dataOffset + compSize);
        let data;
        if (method === 0) {
            data = rawData.slice();
        } else if (method === 8) {
            data = await inflateRaw(rawData);
            if (data.length !== uncompSize) {
                // uncompSize may be 0 if data-descriptor was used; only warn mismatch when non-zero.
                if (uncompSize !== 0) throw new Error(`zip: size mismatch for ${name}`);
            }
        } else {
            throw new Error(`zip: unsupported method ${method} for ${name}`);
        }

        // Skip directory entries (trailing slash).
        if (name.endsWith('/')) continue;
        entries.push({ name, data });
    }
    return entries;
}

// --- ZIP writer -----------------------------------------------------------
/**
 * Build a ZIP buffer from entries in the provided order. All entries are
 * stored with DEFLATE (method 8). Mirrors what JarOutputStream produces.
 *
 * @param {Array<{name: string, data: Uint8Array}>} entries
 * @returns {Promise<Uint8Array>}
 */
export async function zip(entries) {
    // DOS time/date: matches the constant used by Android's build tools
    // (1981-01-01 01:01:00). Not important for correctness.
    const dosTime = (1 << 11) | (1 << 5) | 0;          // 01:01:00
    const dosDate = (1 << 9) | (1 << 5) | 1;           // 1981-01-01

    const chunks = [];
    const cdChunks = [];
    let offset = 0;
    let cdSize = 0;

    for (const e of entries) {
        const nameBytes = TEXT.encode(e.name);
        const uncomp = e.data;
        const comp = await deflateRaw(uncomp);
        const crc = crc32(uncomp);

        // Local File Header
        const lfh = new Uint8Array(30 + nameBytes.length);
        const lv = new DataView(lfh.buffer);
        lv.setUint32(0, LFH_SIG, true);
        lv.setUint16(4, 20, true);         // version needed
        lv.setUint16(6, 0, true);          // flags
        lv.setUint16(8, 8, true);          // method (DEFLATE)
        lv.setUint16(10, dosTime, true);
        lv.setUint16(12, dosDate, true);
        lv.setUint32(14, crc, true);
        lv.setUint32(18, comp.length, true);
        lv.setUint32(22, uncomp.length, true);
        lv.setUint16(26, nameBytes.length, true);
        lv.setUint16(28, 0, true);         // extra len
        lfh.set(nameBytes, 30);
        chunks.push(lfh, comp);

        // Central Directory Header
        const cdh = new Uint8Array(46 + nameBytes.length);
        const cv = new DataView(cdh.buffer);
        cv.setUint32(0, CDH_SIG, true);
        cv.setUint16(4, 20, true);         // version made by
        cv.setUint16(6, 20, true);         // version needed
        cv.setUint16(8, 0, true);          // flags
        cv.setUint16(10, 8, true);         // method
        cv.setUint16(12, dosTime, true);
        cv.setUint16(14, dosDate, true);
        cv.setUint32(16, crc, true);
        cv.setUint32(20, comp.length, true);
        cv.setUint32(24, uncomp.length, true);
        cv.setUint16(28, nameBytes.length, true);
        cv.setUint16(30, 0, true);         // extra len
        cv.setUint16(32, 0, true);         // comment len
        cv.setUint16(34, 0, true);         // disk number
        cv.setUint16(36, 0, true);         // internal attrs
        cv.setUint32(38, 0, true);         // external attrs
        cv.setUint32(42, offset, true);    // LFH offset
        cdh.set(nameBytes, 46);
        cdChunks.push(cdh);

        offset += lfh.length + comp.length;
        cdSize += cdh.length;
    }

    const cdOffset = offset;
    for (const c of cdChunks) chunks.push(c);

    const eocd = new Uint8Array(22);
    const ev = new DataView(eocd.buffer);
    ev.setUint32(0, EOCD_SIG, true);
    ev.setUint16(4, 0, true);
    ev.setUint16(6, 0, true);
    ev.setUint16(8, entries.length, true);
    ev.setUint16(10, entries.length, true);
    ev.setUint32(12, cdSize, true);
    ev.setUint32(16, cdOffset, true);
    ev.setUint16(20, 0, true);
    chunks.push(eocd);

    const total = chunks.reduce((n, c) => n + c.length, 0);
    const out = new Uint8Array(total);
    let off = 0;
    for (const c of chunks) { out.set(c, off); off += c.length; }
    return out;
}
