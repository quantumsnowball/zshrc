ollama.talk-in-oterm() {
    # 1. Start the Ollama container
    echo "🚀 Starting Ollama Server..."
    docker start ollama || docker run -d --gpus all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
    # 2. Wait for the server to be responsive
    echo "⏳ Waiting for server to wake up..."
    until curl -s http://localhost:11434/api/tags > /dev/null; do
        sleep 1
    done
    # 3. Launch oterm
    # When you quit oterm, the script moves to the next line
    oterm
    # 4. Cleanup: Stop the container to free VRAM for gaming
    echo "🛑 Shutting down Ollama to free VRAM..."
    docker stop ollama
    echo "🎮 VRAM cleared!"
}
