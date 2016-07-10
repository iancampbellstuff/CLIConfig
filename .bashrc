alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd......='cd ../../../../..'

alias cd~='cd ~'
alias cd-='cd -'
alias back='cd -'

alias ls='ls -aFhlX --group-directories-first --color=auto'
alias restart='clear; exec bash' # or 'clear; source ~/.bashrc'
alias open='explorer .' # or 'start .'

# example:  findtext "some text"
function findtext() {
        find . -type f -print0 | xargs -0 grep -l "$@" | less
}

# examples:
# - findfiles "*.txt"
# - findfiles "someFile.*"
# - findfiles "*File.txt"
# - findfiles "*File*"
# - findfiles "someFile.txt"
function findfiles() {
        find "`pwd`" -name "$@"
}

