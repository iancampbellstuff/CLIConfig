alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd......='cd ../../../../..'

alias cd~='cd ~'
alias cd-='cd -'
alias back='cd -'

alias ls='ls -alh --color=auto'
alias restart='clear; source ~/.bashrc'
alias open='explorer .' # or 'start .'

# example -- findtext "some text"
function findtext() {
        find . -type f -print0 | xargs -0 grep -l "$@" | less
}
# example -- findfiles "*.txt"
function findfiles() {
        find "`pwd`" -name "$@"
}
