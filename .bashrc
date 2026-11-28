# ~/.bashrc

# History Settings
HISTSIZE=10000
HISTFILE=~/.bash_history
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Keybindings
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# Fastfetch
if command -v fastfetch &>/dev/null; then
	fastfetch
fi

# Aliases
alias ls='ls -a --color=auto'
alias ll='ls -la --color=auto'
alias vi='nvim'
alias vim='nvim'
alias svim='sudo nvim'
alias nfzf='nvim $(fzf -m --preview=bat --color=always {}")'
alias cat='bat'
alias grep='grep --color=auto'
alias rm='trash'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$HOME/.local/npm-global/bin:$PATH"
export GEM_HOME="$(gem env user_gemhome)"
export PATH="$GEM_HOME/bin:$PATH"

# Autostarts
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
