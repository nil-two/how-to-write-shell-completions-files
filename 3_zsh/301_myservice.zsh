#compdef myservice

_myservice() {
  _arguments '1:command:(start stop status help)'
}
compdef _myservice myservice
