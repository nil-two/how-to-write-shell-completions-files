#compdef egame

_egame() {
  _arguments \
    '(-c --color)'{-c,--color}'[color mode for character terminals]:color mode:(auto always never)' \
    '(-g --gui)'{-g,--gui}'[play game on GUI]' \
    '(-h --help)'{-h,--help}'[print usage and exit]' \
    '1: :__egame_games'
}
__egame_games() {
  local dir games
  dir=$(emacs --batch --eval '(princ (locate-library "tetris"))' 2> /dev/null)
  dir=$(dirname "$dir")
  games=( ${(f)"$(ls "$dir" | sed 's/\..*//' | sort | uniq)"} )
  _describe 'game' games
}
compdef _egame egame
