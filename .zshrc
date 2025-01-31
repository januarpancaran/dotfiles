# Zinit Dir
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# If Zinit not installed
if [ ! -d $ZINIT_HOME ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybinds
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab-complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab-complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Fastfetch
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

# Aliases
alias ls='ls -a --color=yes'
alias ll='ls -l --color=yes'
alias vi='nvim'
alias vim='nvim'
alias svim='sudo nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'
alias cat='bat'
alias grep='grep --color=yes'
alias rm='trash-put'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Fzf
source <(fzf --zsh)

# Zoxide
eval "$(zoxide init zsh)"

# Starship
eval "$(starship init zsh)"

