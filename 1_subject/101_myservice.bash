#!/bin/bash
set -eu

cmd=$1
shift
case $cmd in
  start|stop|status|help)
    printf "%s\n" "${0##*/}: not implemented" >&2
    exit 1
    ;;
  *)
    printf "%s\n" "${0##*/}: unrecognized command -- '$cmd'" >&2
    exit 1
    ;;
esac
