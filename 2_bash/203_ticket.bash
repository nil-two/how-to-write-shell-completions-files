_ticket() {
  local cur prev words cword split
  _init_completion -s || return

  case $cword in
    1)
      case $cur in
        -*)
          COMPREPLY=( $(compgen -W '--help' -- "$cur") )
          ;;
        *)
          COMPREPLY=( $(compgen -W 'new edit list' -- "$cur") )
          ;;
      esac
      ;;
    *)
      case ${words[1]} in
        new)
          case $prev in
            -s|--status)
              COMPREPLY=( $(compgen -W 'open closed' -- "$cur") )
              return
              ;;
          esac
          $split && return
          case $cur in
            -*)
              COMPREPLY=( $(compgen -W '--status= --help' -- "$cur") )
              [[ $COMPREPLY == *= ]] && compopt -o nospace
              ;;
          esac
          ;;
        edit)
          case $prev in
            -s|--status)
              COMPREPLY=( $(compgen -W 'open closed' -- "$cur") )
              return
              ;;
          esac
          $split && return
          case $cur in
            -*)
              COMPREPLY=( $(compgen -W '--status= --title= --help' -- "$cur") )
              [[ $COMPREPLY == *= ]] && compopt -o nospace
              ;;
            *)
              COMPREPLY=( $(compgen -W '$(ticket list -f '"'"'$id'"'"')' -- "$cur") )
              ;;
          esac
          ;;
        list)
          case $prev in
            -s|--status)
              COMPREPLY=( $(compgen -W 'open closed all' -- "$cur") )
              return
              ;;
          esac
          $split && return
          case $cur in
            -*)
              COMPREPLY=( $(compgen -W '--format= --status= --help' -- "$cur") )
              [[ $COMPREPLY == *= ]] && compopt -o nospace
              ;;
          esac
          ;;
      esac
      ;;
  esac
}
complete -F _ticket ticket
