# Make vim the default editor.
export EDITOR='vim'

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Man
# Don’t clear the screen after quitting a manual page.
# export MANPAGER='less -X';

# type -P most &> /dev/null && {
#   export MANPAGER='most'
# }

# type -P vim &>/dev/null && {
#   export MANPAGER="vim -c 'set nonumber' -M +MANPAGER - --not-a-term"
# }

PATH="${PATH}:${HOME}/.local/bin"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"

# I use .usr because .local will get polluted by other software installs
export PATH="${PATH}:${HOME}/.usr/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.usr/lib"
# export PREFIX="${HOME}/.usr"
