complete -c egame -s c -l color -xa 'auto always never' -d 'Color mode for character terminals'
complete -c egame -s g -l gui -d 'Play game on GUI'
complete -c egame -s h -l help -d 'Print usage and exit'
complete -c egame -xa '(__complete_egame_games)' -d 'Game'

function __complete_egame_games
  set -l dir (dirname (emacs --batch --eval '(princ (locate-library "tetris"))' 2> /dev/null))
  ls $dir | sed 's/\..*//' | sort | uniq
end
