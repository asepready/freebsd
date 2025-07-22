###############################################
pkg install -y bash bash-completion
###############################################
# ~/.profile - User profile settings
alias lf="ls -FA"
alias ll="ls -lA"
alias su="su -m"

alias vi=vim
export EDITOR=vim
export VISUAL=vim

# BASH
export PS1="[\u@\h \W]\\$ "
