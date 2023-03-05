#!/bin/bash

# controller search universal
consumet_cs-universal() {
    local consumet_url="https://api.consumet.org/anime/$1"

    local keyword=$(gum input --placeholder 'Enter anime name' | tr ' ' '+')
    local resp=$(curl -s "$consumet_url/$keyword")

    local titles=$(printf "$resp" | jq -r '.results[] | .title')
    local data=()

    if [[ $titles == "" ]]; then
        printf '%s\n' "No animes found."
        exit 1
    fi

    while read -r line; do
        data+=("$line")
    done <<<"$titles"

    if [ ${#data[@]} -eq 0 ]; then
        printf '%s\n' "No animes found."
        exit 1
    fi

    local title=$(gum choose "${data[@]}")

    echo "$resp" |
        jq -r ".results[] | select(.title == \"$title\") | .id"
}

# controller episode universal
consumet_ce-universal() {
    local consumet_url="https://api.consumet.org/anime/$1/info/$2"
    local resp=$(curl -s "$consumet_url")

    local total_episodes=$(echo "$resp" | jq -r '.totalEpisodes')

    if ! [[ $total_episodes =~ ^[0-9]+$ ]]; then
        printf 'Invalid total episodes returned \n'
        exit 1
    fi

    local episode=$(eval "gum choose {1..$total_episodes} --height 1")

    echo "$resp" |
        jq -r ".episodes[] | select(.number == $episode) | .id"
}

# controller watch universal
consumet_cw-universal() {
    local consumet_url="https://api.consumet.org/anime/$1/watch/$2"
    local resp=$(curl -s "$consumet_url")

    local sources=$(echo "$resp" | jq -r '.sources[] | .quality')
    local data=()

    if [[ $sources == "" ]]; then
        printf '%s\n' "No sources found."
        exit 1
    fi

    while read -r line; do
        data+=("$line")
    done <<<"$sources"

    if [ ${#data[@]} -eq 0 ]; then
        printf '%s\n' "No sources found."
        exit 1
    fi

    local source=$(gum choose "${data[@]}")

    echo "$resp" |
        jq -r ".sources[] | select(.quality == \"$source\") | .url"
}

# __CONTROLLER__ 9anime
consumet_c-9anime() {
    anime_id=$(consumet_cs-universal '9anime')

    if [ "$anime_id" == "" ]; then
        printf '%s\n' "No anime id returned."
        exit 1
    fi

    episode_id=$(consumet_ce-universal '9anime' "$anime_id")

    if [ "$episode_id" == "" ]; then
        printf '%s\n' "No episode id returned."
        exit 1
    fi

    consumet_cw-universal '9anime' "$episode_id"
}

# __CONTROLLER__ gogoanime
consumet_c-gogoanime() {
    anime_id=$(consumet_cs-universal 'gogoanime')

    if [ "$anime_id" == "" ]; then
        printf '%s\n' "No anime id returned."
        exit 1
    fi

    episode_id=$(consumet_ce-universal 'gogoanime' "$anime_id")

    if [ "$episode_id" == "" ]; then
        printf '%s\n' "No episode id returned."
        exit 1
    fi

    consumet_cw-universal 'gogoanime' "$episode_id"
}

# __CONTROLLER__ animepahe
consumet_c-animepahe() {
    anime_id=$(consumet_cs-universal 'animepahe')

    if [ "$anime_id" == "" ]; then
        printf '%s\n' "No anime id returned."
        exit 1
    fi

    episode_id=$(consumet_ce-universal 'animepahe' "$anime_id")

    if [ "$episode_id" == "" ]; then
        printf '%s\n' "No episode id returned."
        exit 1
    fi

    consumet_cw-universal 'animepahe' "$episode_id"
}

# Initialize the plugin
__INIT__() {
    components["consumet:controller:animepahe"]=consumet_c-animepahe
    components["consumet:controller:9anime"]=consumet_c-9anime
    components["consumet:controller:gogoanime"]=consumet_c-gogoanime
}
