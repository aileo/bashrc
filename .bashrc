# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# UTF8 FTW
export LC_ALL=fr_FR.utf8
export LANG="$LC_ALL"

# don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  color_prompt=yes
  else
  color_prompt=
  fi
fi

# get current path branch if git repository
function showGitBranch() {
    if ( `git rev-parse > /dev/null 2>&1` ) ; then
        GITBRANCH=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ "$GITBRANCH" != "" ]
        then echo -n " $GITBRANCH"
        else echo -n " [none]"
        fi
    fi
}

# get current path stats if git repository
function showGitStats() {
    GITSTATS=""

    if ( `git rev-parse > /dev/null 2>&1` ) ; then
        GITSTATS+="(${BoGreen}+$(git ls-files --other --exclude-standard | wc -l)${RCol} ";
        GITSTATS+="${BoBlue}$(git ls-files --modified | wc -l)${RCol} ";
        GITSTATS+="${BoRed}-$(git ls-files --deleted | wc -l)${RCol})";
    fi
    echo -n $GITSTATS
}

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local EXIT="$?"
    PS1=""

    local RCol='\[\033[0m\]'

    local Red='\[\033[0;31m\]'
    local BoRed='\[\033[1;31m\]'
    local BlRed='\[\033[5;31m\]'

    local Green='\[\033[0;32m\]'
    local BoGreen='\[\033[1;32m\]'
    local BlGreen='\[\033[5;32m\]'

    local Yellow='\[\033[0;33m\]'
    local BoYellow='\[\033[1;33m\]'
    local BlYellow='\[\033[5;33m\]'

    local Blue='\[\033[0;34m\]'
    local BoBlue='\[\033[1;34m\]'
    local BlBlue='\[\033[5;34m\]'

    local Cyan='\[\033[0;36m\]'
    local BoCyan='\[\033[1;36m\]'
    local BlCyan='\[\033[5;36m\]'

    local Purple='\[\033[0;35m\]'
    local BoPurple='\[\033[1;35m\]'
    local BlPurple='\[\033[5;35m\]'

    if [ $EXIT != 0 ]
    then PS1+="${BoRed}${RCol} "
    else PS1+="${BoGreen}${RCol} "
    fi

    PS1+="\t"
    PS1+=" ${BoYellow}\u"
    # PS1+="${Yellow}@\h${RCol}"
    PS1+=" - ${Cyan}\w${RCol}"
    PS1+="${BoCyan}$(showGitBranch)${RCol}"
    PS1+="$(showGitStats)${RCol}"
    PS1+="\n "
}

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
    ssh-add
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
