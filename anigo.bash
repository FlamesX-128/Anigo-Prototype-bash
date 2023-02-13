#!/bin/bash

# Global variables
declare -a s_controllers
declare -A components

plugin_map='anigo/plugins.map'
anigo_dir='anigo/plugins'

# Symbol Pattern
c_pattern="$(openssl rand -hex 8)"

# Create directory if it doesn't exist
mkdir -p $anigo_dir

# Create plugin map if it doesn't exist
if [ ! -f $config_path ]; then
    curl -s https://raw.githubusercontent.com/FlamesX-128/test/main/plugins.map -o $config_path
fi

# Install plugins
while read url; do
    if test -f $anigo_dir/$(basename $url); then
        printf 'Plugin %s already installed \n' "$url"
        continue
    fi

    printf 'Installing plugin %s \n' "$url"

    curl -s $url -o $anigo_dir/$(basename $url)
    chmod +x $anigo_dir/$(basename $url)
done < <(jq -r '.[]' $plugin_map)

# Load plugins
for entry in $anigo_dir/*; do
    if [[ $entry != *.bash ]]; then
        continue
    fi

    printf 'Loading plugin %s \n' "$entry"
    source "$entry"

    __INIT__ "$(openssl rand -hex 8)"
done


while true; do
    # Get controllers
    for key in "${!components[@]}"; do
        if [[ $key == *"controller"* ]]; then
            s_controllers+=("$key")
        fi
    done

    # Print controllers
    for i in "${!s_controllers[@]}"; do
        printf '%s \n' "> $i: ${s_controllers[$i]:28}"
    done


    # Select controller
    while true; do
        read -p "Select a controller: " controller

        if [[ $controller =~ ^[0-9]+$ ]]; then
            if [[ $controller -ge 0 && $controller -lt ${#s_controllers[@]} ]]; then
                break
            fi
        fi

        printf 'Invalid input \n'
    done

    # Call controller
    ${components[${s_controllers[$controller]}]} "$@"
done
