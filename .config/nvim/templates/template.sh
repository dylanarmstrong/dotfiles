#!/usr/bin/env bash

set -eEu -o pipefail

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}")
EOF
  exit
}

%{CURSOR}
