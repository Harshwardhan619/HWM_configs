# Setup fzf
# ---------
if [[ ! "$PATH" == */home/username/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/username/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/username/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/username/.fzf/shell/key-bindings.bash"
