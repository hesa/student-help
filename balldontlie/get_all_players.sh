#!/bin/bash

PAGE_COUNT=100
url="https://www.balldontlie.io/api/v1/stats?seasons[]=2019&per_page=$PAGE_COUNT";


#
# Verify that jq is installed
#
jq --version >/dev/null 2 >/dev/null
if [ $? -ne 0 ]
then
    echo "jq, does not seem to be installed."
    exit 2
fi

webget()
{
    curl -s "$1"
}

#
# function to get (write to stdout) the nr of pages
#
get_nr_pages()
{
    webget "$1" | jq '.meta.total_pages'
}

#
# function to get $PAGE_COUNT players and from PAGE (param) page
#
get_players()
{
    PAGE=$1
    webget "$url&page=$PAGE" | jq '.data[].player.first_name' | tr '[\n]' ' | '
}


#
# invoke get_nr_pages
# store "result" (actually printout) in variable nr_pages
#
nr_pages=$(get_nr_pages "$url")

page=0
while [ $page -lt $nr_pages ]
do
    echo "Page $page of $nr_pages:"
    echo -n "[ "
    get_players "$page"
    echo " ]"
    page=$(( $page + 1 ))
    
done

