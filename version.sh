#!/bin/bash
FILE_API=CHANGELOG.md
COMMIT=$(git log);
printf "%s" "$COMMIT" > $FILE_API
