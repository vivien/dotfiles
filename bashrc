# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
if [[ -n "$PS1" ]] ; then

    # don't put duplicate lines in the history. See bash(1) for more options
    # don't overwrite GNU Midnight Commander's setting of `ignorespace'.
    HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
    # ... or force ignoredups and ignorespace
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # Customize PS1 with Git routines
    GIT_PS1_SHOWDIRTYSTATE=true # Add Git dirty state mark to PS1
    GIT_PS1_SHOWSTASHSTATE=true # Show if something is stashed
    GIT_PS1_SHOWUNTRACKEDFILES=true # Show if there're untracked files

    # set it to 'yes' if you want colored prompt
    color_prompt=yes

    if [ "$color_prompt" = yes ]; then
        # Colors ('[01;' for bold and '[00;' for non-bold)
        # Gray    \[\033[01;30m\]
        # Red     \[\033[01;31m\]
        # Green   \[\033[01;32m\]
        # Yellow  \[\033[01;33m\]
        # Blue    \[\033[01;34m\]
        # Magenta \[\033[01;35m\]
        # Cyan    \[\033[01;36m\]
        # White   \[\033[01;37m\]
        # Normal  \[\033[00m\]
        PS1='($(date +%R)) \[\033[01;34m\]\w$(__git_ps1 "\[\033[01;37m\]@\[\033[00;31m\]%s")\n\[\033[01;37m\]\$\[\033[00m\] '
    else
        PS1='($(date +%R)) \w$(__git_ps1 "@%s")\n\$ '
    fi

    unset color_prompt

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # some more ls aliases
    #alias ll='ls -l'
    #alias la='ls -A'
    #alias l='ls -CF'

    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.

    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

fi # end of 'if [[ -n "$PS1" ]] ; then'

# This is a good place to source rvm v v v (loads RVM into a shell session).
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Set the EDITOR variable
export EDITOR='vim'

# Are dotfiles clean?
dotfiles

