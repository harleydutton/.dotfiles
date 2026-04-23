# .bashrc
# Only show if interactive AND stdout is a terminal (not a pipe)
if [[ $- == *i* ]] && [ -t 1 ]; then
    echo "Reminder: Install ZSH and chsh"
fi

# Bandaid Settings
# .inputrc makes tab-complete case insensitive
export HISTFILE=~/.histfile

export PATH=/home/hdutton/.local/bin:$PATH
. "$HOME/.cargo/env"
