#!/bin/bash

# Function to fetch and parse links from a webpage
crawl() {
    local url=$1
    local html=$(wget -q -O - "$url")

    # Extract links using pattern matching
    local links=$(echo "$html" | grep -o '<a [^>]*href="[^"]*"' | sed 's/<a [^>]*href="\([^"]*\)"/\1/g')

    # Process each link
    for link in $links; do
        # Check if it's an absolute URL or relative
        if [[ $link == /* ]]; then
            link="${url%/*}$link"
        elif [[ $link != http* ]]; then
            link="$url$link"
        fi

        # Print the link
        echo "$link"
    done
}

# Check if URL is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

# Start crawling from the provided URL
crawl "$1"

