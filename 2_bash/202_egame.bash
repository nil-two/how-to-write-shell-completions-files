_egame() {
  local cur prev words cword split
  _init_completion -s || return

  case $prev in
    -c|--color)
      COMPREPLY=( $(compgen -W 'auto always never' -- "$cur") )
      return
      ;;
  esac
  $split && return

  case $cur in
    -*)
      COMPREPLY=( $(compgen -W '--color= --gui --help' -- "$cur") )
      [[ $COMPREPLY == *= ]] && compopt -o nospace
      ;;
    *)
      local dir games
      dir=$(emacs --batch --eval '(princ (locate-library "tetris"))' 2> /dev/null)
      dir=$(dirname "$dir")
      games=( $(ls "$dir" | sed 's/\..*//' | sort | uniq) )
      COMPREPLY=( $(compgen -W '"${games[@]}"' -- "$cur") )
      ;;
  esac
}
complete -F _egame egame
