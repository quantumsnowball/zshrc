installed qdbus6 || return


kde.kwin-script.kronhnkite.unload() {
    qdbus6 org.kde.KWin /Scripting unloadScript "krohnkite"
}
kde.kwin-script.kronhnkite.reload() {
    kde.kwin-script.kronhnkite.unload
    qdbus6 org.kde.KWin /Scripting start
}
