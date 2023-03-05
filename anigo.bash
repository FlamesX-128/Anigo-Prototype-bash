#! /bin/bash

# Global variables
declare -A components

#
plug_uri='https://raw.githubusercontent.com/FlamesX-128/test/main/config.json'

conf_dir='anigo/config.json'
plug_dir='anigo/plugins'

# ---
InstallPluginMap() {
    gum spin -s minidot --title 'Downloading plugin map...' -- \
        curl -s "$plug_uri" -o "$conf_dir"
}

ReadPluginMap() {
    jq -r '.plugins[]' "$conf_dir"
}

# ---
InstallPlugin() {
    local base=$(basename $1)

    gum spin -s minidot --title "Downloading plugin \"$base\" ..." -- \
        curl -s "$1" -o "$plug_dir/$base"

    chmod +x "$plug_dir/$base"
}

# ---
LoadPlugin() {
    local base=$(basename $1)

    if [[ $entry != *.bash && $entry != *.sh ]]; then
        return
    fi

    #gum spin -s minidot --title "Loading plugin \"$base\"" -- \
    #    source "$1" && __INIT__

    printf 'Loading plugin %s \n' "$1"

    eval source "$1"
    __INIT__
}

# ---
Init() {
    if [ ! -f $conf_dir ]; then
        InstallPluginMap
    fi

    while read url; do
        if test -f $plug_dir/$(basename $url); then
            continue
        fi

        InstallPlugin $url
    done < <(ReadPluginMap)

    for entry in $plug_dir/*; do
        LoadPlugin $entry
    done
}

# ---
Main() {
    local -a controllers=()
    local -a filtered=()

    # Filter components
    for key in "${!components[@]}"; do
        if [[ $key == *"controller"* ]]; then
            filtered+=("${key}")
        fi
    done

    for key in "${filtered[@]}"; do
        local name=$(printf "$key" |  sed -E 's/controller:(.*)/\1/')

        controllers+=(
            $(printf "$key " |  sed -E 's/controller:(.*)/\1/')
        )
    done

    if [ ${#controllers[@]} -eq 0 ]; then
        printf '%s\n' "No controllers found."
        exit 1
    fi

    local resp=$(gum choose "${controllers[@]}")
    local resp="${resp//:/\:controller:}"

    url=$(${components[$resp]})

    if [ "$url" == "" ]; then
        printf '%s\n' "No url found."
        exit 1
    fi

    cmd=$(jq -r '.watch' "$conf_dir")

    if [ "$cmd" == "" ]; then
        printf '%s\n' "No watch command found."
        exit 1
    fi

    eval "$cmd $url"
}

# ---

Init
Main
