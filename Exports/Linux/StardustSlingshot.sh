#!/bin/sh
echo -ne '\033c\033]0;Stardust Slingshots\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/StardustSlingshot.x86_64" "$@"
