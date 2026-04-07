ollama.stop-all-models() {
    local running_models=$(ollama ps | awk 'NR>1 {print $1}')

    if [ -z "$running_models" ]; then
        printf "\n${GREEN}No models are currently running.${RESET}\n"
        return 0
    fi

    echo "Stopping models: $running_models"
    for model in $running_models; do
        ollama stop "$model"
    done

    printf "\n${GREEN}VRAM cleared.${RESET}\n"
}
alias ollama.free='ollama.stop-all-models'

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
