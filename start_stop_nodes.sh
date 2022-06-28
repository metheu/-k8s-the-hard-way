#!/bin/bash

CMD="$1"

if [[ -z "$CMD" ]]; then
  echo "Please enter a vagrant command!" && exit 1
 fi

for i in {1..5};
do
  vagrant "$CMD" node$i
done