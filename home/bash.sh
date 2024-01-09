export HISTSIZE=-1 HISTFILESIZE=-1 HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
