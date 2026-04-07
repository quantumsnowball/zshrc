ensure ollama || return 


# ollama free up resources
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

# ollama
installed nvim.ai && alias ollama.talk-in-nvim='nvim.ai'
