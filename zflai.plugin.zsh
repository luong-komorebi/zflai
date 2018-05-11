ZERO="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

zmodload zsh/datetime
zmodload zsh/system
autoload zflai_check_start zflai_memory_keeper

typeset -g ZFLAI_FD=0 ZFLAI_NULL_FD=0 ZFLAI_LAST_LOG="$EPOCHSECONDS" ZFLAI_KEEP_ALIVE=45

# Loads configuration from zstyle database into
# global variables, for direct and quicker access.
#
# No input, no return value (always true).
function zflai_refresh_config {
    builtin zstyle -s ":plugin:zflai" keep_alive_time ZFLAI_KEEP_ALIVE || ZFLAI_KEEP_ALIVE=45
    return 0
}


# Receives log message, sends it to in-memory
# log-keeper process.
#
# $1 - log message
function zflai-log {
    zflai_check_start
    print -u $ZFLAI_FD -r -- "$1"
    ZFLAI_LAST_LOG="$EPOCHSECONDS"
}

# Initial read of configuration 
zflai_refresh_config

exec {ZFLAI_NULL_FD}>/dev/null

# vim:ft=zsh:et
