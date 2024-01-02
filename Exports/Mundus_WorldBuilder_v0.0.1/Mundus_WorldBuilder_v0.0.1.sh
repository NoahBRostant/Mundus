#!/bin/sh
echo -ne '\033c\033]0;Mundus (World Builder)\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Mundus_WorldBuilder_v0.0.1.x86_64" "$@"
