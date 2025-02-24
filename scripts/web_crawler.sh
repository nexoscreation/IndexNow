#!/bin/bash

# Load Configuration
source ./config/settings.env

# Log file
LOG_FILE="./logs/web_crawler.log"
URLS_FILE="./urls.txt"

# User-Agent for crawling (Modify if needed)
USER_AGENT="Mozilla/5.0 (compatible; IndexNowBot/1.0)"

# Function to extract URLs from a webpage
extract_urls() {
    local PAGE_URL="$1"
    echo "🔍 Crawling: $PAGE_URL" | tee -a "$LOG_FILE"

    # Fetch the page and extract all links
    curl -s -A "$USER_AGENT" "$PAGE_URL" | \
        grep -oP '(?<=href=")[^"]+' | \
        grep -E '^https?://' | \
        grep -vE '\.(jpg|jpeg|png|gif|svg|pdf|css|js)$' | \
        sort -u >> "$URLS_FILE"

    echo "✅ Found $(wc -l < "$URLS_FILE") unique URLs so far!" | tee -a "$LOG_FILE"
}

# Recursive function to crawl multiple pages
crawl_website() {
    local START_URL="$1"
    echo "🚀 Starting crawl at: $START_URL" | tee -a "$LOG_FILE"

    # Initialize URL list
    echo "$START_URL" > "$URLS_FILE"

    # Loop through discovered URLs
    while read -r url; do
        extract_urls "$url"
    done < "$URLS_FILE"

    echo "✅ Crawling completed. Total URLs found: $(wc -l < "$URLS_FILE")" | tee -a "$LOG_FILE"
}

# Help Guide
if [[ "$1" == "-u" && -n "$2" ]]; then
    crawl_website "$2"
else
    echo "Usage:"
    echo "  $0 -u <START_URL>   # Start crawling from a given URL"
    exit 1
fi
