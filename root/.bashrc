#
# ~/.bashrc
#

# Make sure ccache is not missed
which ccache &>/dev/null
if (( $? == 0 )); then
	export PATH=/usr/lib/ccache/bin:$PATH
	export USE_CCACHE=1
fi

# Include local user binaries in PATH
export PATH=$HOME/.local/bin:$HOME/bin:$PATH

# If not running interactively, don't do anything else
[[ $- != *i* ]] && return

# Python virtualenvs setup
if [[ -e /usr/bin/virtualenvwrapper_lazy.sh ]]; then
	export WORKON_HOME=~/.virtualenvs
	[[ ! -d $WORKON_HOME ]] && mkdir $WORKON_HOME
	. /usr/bin/virtualenvwrapper_lazy.sh
fi

# Enable 256-color GUI terminals
[ "$TERM" != "linux" ] && export TERM=xterm-256color

# Prompt
(( EUID == 0 )) && user_col='1' || user_col='2' # Color username depending on root access
PS1='\[\e[3'$user_col'm\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\] \[\e[33m\]\W \[\e[35m\]\A\[\e[m\] \$ ' # '\u@\h \W \A \$ ' (\D{%-I:%M%p}) (\A)
unset user_col

# Load extra bash completions
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# Load additional functions & aliases
[[ -e ~/.bashrc_misc ]] && . ~/.bashrc_misc

# less & man pages colors
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

# Misc config
export EDITOR=vim
export PAGER=less             # No one likes more, right? :)
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL=ignoreboth # No duplicate / commands that start with a ' ' in history entries
export HISTSIZE=10000         # Increase default command history size from 500 lines
shopt -s histappend           # Append to rather than overwrite history file
complete -cf sudo             # Sudo completions