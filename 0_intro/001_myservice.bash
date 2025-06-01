_myservice() {
    local cur prev words cword split
    _init_completion || return
    COMPREPLY=( $(compgen -W 'start stop status help' -- "$cur") )
}
complete -F _myservice myservice
