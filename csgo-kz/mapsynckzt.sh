#!/bin/bash

collections=(1942732975 1942753106 1942767730 1942784132 1942796140)

# Loop over collections and grab each map's ID
ids=()
for id in ${collections[@]}; do
    collection=$(curl --silent -H "Content-Type: application/x-www-form-urlencoded" \
        -d "collectioncount=1" \
        -d "publishedfileids[0]=$id" \
        https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/)

    keys=$( echo "$collection" | jq -r ".response | .collectiondetails[0] | .children | keys | .[]")

    for key in $keys; do
        item=$( echo "$collection" | jq -r ".response | .collectiondetails[0] | .children | nth($key) | .publishedfileid")
        ids+=($item)
    done
done

# Grab a list of maps that are on the server
maps=()
for dir in $(find -type d); do
    map=$( echo $dir | sed -e "s%./%%")

    if [[ $map =~ [[:digit:]]{3,} ]]; then
        maps+=($map)
    fi
done

# Loop over workshop items, comparing versions and downloading if needed.
# Subtract from maps=() and then loop over what's remaining and remove that.
for id in ${ids[@]}; do
    response=$(curl --silent -H "Content-Type: application/x-www-form-urlencoded" \
        -d "itemcount=1" \
        -d "publishedfileids[0]=$id" \
        https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/)

    name=$( echo $response | jq -r ".response | .publishedfiledetails[0] | .filename" | sed -e "s%mymaps/%%")
    size=$( echo $response | jq -r ".response | .publishedfiledetails[0] | .file_size")
    url=$( echo $response | jq -r ".response | .publishedfiledetails[0] | .file_url")

    if [ ! -d "$id" ] || [ ! -f "$id/$name" ]; then
        # Does not exist, download.
        mkdir -p $id
        wget -q --show-progress $url -O $id/$name
    else
        # Exists, compare size & download if differ
        if [ $size != $(stat --printf="%s" $id/$name) ]; then
            wget -q --show-progress $url -O $id/$name
        fi
    fi
    maps=(${maps[@]/$id})
done

# Maps that are downloaded, but don't exist in the collection anymore.
for map in ${maps[@]}; do
    rm -r $map
done