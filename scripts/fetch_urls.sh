#!/bin/bash

# Load Configuration
source ./config/settings.env

# Log file
LOG_FILE="./logs/fetch_urls.log"

# Function to extract URLs from a sitemap
fetch_sitemap_urls() {
    local SITEMAP_URL="$1"
    echo "🔍 Fetching URLs from sitemap: $SITEMAP_URL" | tee -a "$LOG_FILE"
    
    curl -s "$SITEMAP_URL" | grep -oP '(?<=<loc>)[^<]+' | sort -u > urls.txt

    if [ -s urls.txt ]; then
        echo "✅ Found $(wc -l < urls.txt) URLs from sitemap!" | tee -a "$LOG_FILE"
    else
        echo "❌ No URLs found in sitemap!" | tee -a "$LOG_FILE"
    fi
}

# Function to extract URLs from a webpage
fetch_page_links() {
    local PAGE_URL="$1"
    echo "🔍 Fetching URLs from page: $PAGE_URL" | tee -a "$LOG_FILE"

    curl -s "$PAGE_URL" | grep -oP '(?<=href=")[^"]+' | grep -E '^https?://' | sort -u > urls.txt

    if [ -s urls.txt ]; then
        echo "✅ Found $(wc -l < urls.txt) URLs from page!" | tee -a "$LOG_FILE"
    else
        echo "❌ No URLs found on page!" | tee -a "$LOG_FILE"
    fi
}

# Function to clean and filter valid URLs
clean_urls() {
    echo "🧹 Cleaning and filtering URLs..." | tee -a "$LOG_FILE"
    
    grep -E "^https?://" urls.txt | sort -u > urls_clean.txt
    mv urls_clean.txt urls.txt

    echo "✅ $(wc -l < urls.txt) valid URLs remaining after cleanup!" | tee -a "$LOG_FILE"
}

# Help Guide
if [[ "$1" == "-s" && -n "$2" ]]; then
    fetch_sitemap_urls "$2"
    clean_urls
elif [[ "$1" == "-p" && -n "$2" ]]; then
    fetch_page_links "$2"
    clean_urls
else
    echo "Usage:"
    echo "  $0 -s <SITEMAP_URL>   # Fetch & clean URLs from a sitemap"
    echo "  $0 -p <PAGE_URL>      # Fetch & clean URLs from a webpage"
    exit 1
fi
