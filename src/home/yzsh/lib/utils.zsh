err() {
  echo "ERROR> $*" >&2
}

inf() {
  echo "INFO> $*"
}

infn() {
  echo -n "INFO> $*"
}

debug() {
  # its a zsh fine solution but it leads to issues with shellscript and vscode
  # [[ "${ENV:l}" = (testing|test|debug) ]] && echo "DEBUG> $*"
  [[ "${ENV:l}" = 'testing' || "${ENV:l}" = 'test' || "${ENV:l}" = 'debug' ]] &&
    echo "DEBUG> $*"
}
