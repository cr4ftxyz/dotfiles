if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_DEFAULT_SESSION_NAME=cr4ftx

plugins=(
    sudo
    vi-mode
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
    git
    terraform
    docker-compose
    docker
    yarn
    nvm
    npm
    brew
    ripgrep
)

source $ZSH/oh-my-zsh.sh

# set better pager with bat
export AWS_PAGER=""
if command -v bat &> /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# load scripts
if [[ -d /opt/homebrew/bin ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ -d /home/linuxbrew/.linuxbrew/bin ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v zoxide >& /dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
if [[ -d ~/.fzf-tab-completion ]]; then
    source ~/.fzf-tab-completion/zsh/fzf-zsh-completion.sh
fi

# add zsh hook to auto change node version based on .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "\$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
            nvm use
        fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}
add-zsh-hook chpwd load-nvmrc

# aliases
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
if command -v eza &> /dev/null; then
    alias ll="eza --long --icons --group --git --total-size"
    alias l="eza --long --icons --group --git --total-size --all"
    alias tree="eza --tree --icons --git --ignore-glob=.git --all"
fi
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
