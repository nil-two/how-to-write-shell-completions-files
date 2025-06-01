#compdef ticket

_ticket() {
  _arguments \
    '(-h --help)'{-h,--help}'[show this help message and exit]' \
    '1: :->command' \
    '*:: :->sub_command'
  case $state in
    command)
      _values 'command' \
        'new[create a new ticket]' \
        'edit[edit a ticket]' \
        'list[list tickets]'
      ;;
    sub_command)
      case $words[1] in
        new)
          _arguments \
            '(-s --status)'{-s,--status}'[ticket status]:status:(open closed)' \
            '(-h --help)'{-h,--help}'[show this help message and exit]' \
            '1:title:'
          ;;
        edit)
          _arguments \
            '(-s --status)'{-s,--status}'[ticket status]:status:(open closed)' \
            '(-t --title)'{-t,--title}'[ticket title]:title:' \
            '(-h --help)'{-h,--help}'[show this help message and exit]' \
            '1: :__ticket_ids'
          ;;
        list)
          _arguments \
            '(-f --format)'{-f,--format}'[output format in Python string.Template]:format:' \
            '(-s --status)'{-s,--status}'[ticket status]:status:(open closed all)' \
            '(-h --help)'{-h,--help}'[print usage and exit]'
          ;;
      esac
      ;;
  esac
}
__ticket_ids() {
  local ids=( ${(f)"$(ticket list -f '$id:$title')"} )
  _describe 'ticket id' ids
}
compdef _ticket ticket
