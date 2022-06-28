#!/bin/bash

PATTERN="$1"
CMD="$2"

if [[ -z "$PATTERN" || -z "$CMD" ]]; then
  echo "How to use: ./run_cmd.sg <ANSIBLE_PATTERN> \"<CMD_TO_RUN>\" " && exit 1
fi

echo "Running command: ansible "$PATTERN" -i hosts.ini --key-file ./node --forks 1 -u vagrant -a \""$CMD"\" "
ansible "$PATTERN" -i hosts.ini --key-file ./node --forks 1 -u vagrant -a "$CMD" 
