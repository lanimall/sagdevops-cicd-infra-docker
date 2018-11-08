#!/bin/sh
set -e

# if managed image (SPM is present)
if [ -d "$SAG_HOME/profiles/SPM/bin" ]; then
    # start spm and self-register
    $SAG_HOME/register.sh
fi

if [ $# -gt 0 ]; then
    exec "$@"
    if [ "$EXIT_AFTER_COMMAND" == "true" ]; then
        exit 1
    fi
fi

# staying online before force stop container
tail -f /dev/null