#!/bin/bash

# Load Configuration
source ./config/settings.env

# Define Search Engines
ENGINES=("https://api.indexnow.org")

# Log files
LOG_FILE="./logs/indexnow.log"
FAILED_LOG="./logs/failed_urls.log"

# Function to encode URLs properly
url_encode() {
    local url="$1"
    echo -n "$url"
}

# Function to submit a single URL
submit_single_url() {
    local URL_TO_INDEX=$(url_encode "$1")
    for ENGINE in "${ENGINES[@]}"; do
        INDEXNOW_URL="$ENGINE/indexnow?url=$URL_TO_INDEX&key=$API_KEY"
        
        if [ -n "$KEY_LOCATION" ]; then
            INDEXNOW_URL="$INDEXNOW_URL&keyLocation=$(url_encode "$KEY_LOCATION")"
        fi
        
        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$INDEXNOW_URL")

        case $RESPONSE in
            200) echo "✅ [$ENGINE] $1 - Submitted Successfully" | tee -a "$LOG_FILE" ;;
            202) echo "⚠️ [$ENGINE] $1 - Accepted (Key Validation Pending)" | tee -a "$LOG_FILE" ;;
            400) echo "❌ [$ENGINE] $1 - Bad Request (Invalid Format)" | tee -a "$FAILED_LOG" ;;
            403) echo "❌ [$ENGINE] $1 - Forbidden (Invalid Key or Key Not Found)" | tee -a "$FAILED_LOG" ;;
            422) echo "❌ [$ENGINE] $1 - Unprocessable (URL doesn't match host)" | tee -a "$FAILED_LOG" ;;
            429) echo "❌ [$ENGINE] $1 - Too Many Requests (Rate Limit Reached)" | tee -a "$FAILED_LOG" ;;
            *)   echo "❌ [$ENGINE] $1 - Unknown Error (HTTP $RESPONSE)" | tee -a "$FAILED_LOG" ;;
        esac
    done
}

# Function to submit multiple URLs without jq
submit_bulk_urls() {
    local FILE="$1"

    # Ensure file exists and is not empty
    if [[ ! -f "$FILE" || ! -s "$FILE" ]]; then
        echo "❌ No URLs found for bulk submission!" | tee -a "$FAILED_LOG"
        exit 1
    fi

    # Read URLs and format JSON properly
    JSON_PAYLOAD="{\"host\":\"$HOST\",\"key\":\"$API_KEY\",\"urlList\":["

    while IFS= read -r URL; do
        JSON_PAYLOAD+="\"${URL}\","
    done < "$FILE"

    # Remove last comma and close JSON array
    JSON_PAYLOAD="${JSON_PAYLOAD%,}]}"
    
    echo "📤 Submitting bulk URLs to IndexNow..." | tee -a "$LOG_FILE"
    echo "📜 JSON Payload: $JSON_PAYLOAD"  # Debugging: Remove this line in production

    for ENGINE in "${ENGINES[@]}"; do
        RESPONSE=$(curl -s -o response.txt -w "%{http_code}" -X POST \
            -H "Content-Type: application/json" \
            -d "$JSON_PAYLOAD" \
            "$ENGINE/indexnow")

        RESPONSE_BODY=$(cat response.txt)

        case $RESPONSE in
            200) echo "✅ [$ENGINE] Bulk URLs Submitted Successfully" | tee -a "$LOG_FILE" ;;
            202) echo "⚠️ [$ENGINE] Bulk URLs Accepted (Key Validation Pending)" | tee -a "$LOG_FILE" ;;
            400) echo "❌ [$ENGINE] Bulk Submission Failed (Bad Request): $RESPONSE_BODY" | tee -a "$FAILED_LOG" ;;
            403) echo "❌ [$ENGINE] Bulk Submission Failed (Invalid Key): $RESPONSE_BODY" | tee -a "$FAILED_LOG" ;;
            422) echo "❌ [$ENGINE] Bulk Submission Failed (Invalid URLs): $RESPONSE_BODY" | tee -a "$FAILED_LOG" ;;
            429) echo "❌ [$ENGINE] Bulk Submission Failed (Rate Limit Exceeded): $RESPONSE_BODY" | tee -a "$FAILED_LOG" ;;
            *)   echo "❌ [$ENGINE] Bulk Submission Failed (HTTP $RESPONSE): $RESPONSE_BODY" | tee -a "$FAILED_LOG" ;;
        esac
    done
}

# Function to fetch URLs from sitemap & submit them
fetch_sitemap_urls() {
    local SITEMAP_URL="$1"
    echo "🔍 Fetching URLs from sitemap: $SITEMAP_URL" | tee -a "$LOG_FILE"
    
    curl -s "$SITEMAP_URL" | grep -oP '(?<=<loc>)[^<]+' | sort -u > urls.txt
    
    if [[ -s urls.txt ]]; then
        echo "✅ Found $(wc -l < urls.txt) URLs in sitemap. Submitting now..." | tee -a "$LOG_FILE"
        submit_bulk_urls urls.txt
    else
        echo "❌ No URLs found in sitemap!" | tee -a "$FAILED_LOG"
        exit 1
    fi
}

# Function to fetch URLs from a web page & submit them
fetch_page_links() {
    local PAGE_URL="$1"
    echo "🔍 Fetching URLs from page: $PAGE_URL" | tee -a "$LOG_FILE"

    curl -s "$PAGE_URL" | grep -oP '(?<=href=")[^"]+' | grep -E '^https?://' | sort -u > urls.txt

    if [[ -s urls.txt ]]; then
        echo "✅ Found $(wc -l < urls.txt) URLs on the page. Submitting now..." | tee -a "$LOG_FILE"
        submit_bulk_urls urls.txt
    else
        echo "❌ No URLs found on page!" | tee -a "$FAILED_LOG"
        exit 1
    fi
}

# Usage Guide
if [[ "$1" == "-s" && -n "$2" ]]; then
    fetch_sitemap_urls "$2"
elif [[ "$1" == "-p" && -n "$2" ]]; then
    fetch_page_links "$2"
elif [[ "$1" == "-u" && -n "$2" ]]; then
    submit_single_url "$2"
elif [[ "$1" == "-f" && -f "$2" ]]; then
    submit_bulk_urls "$2"
else
    echo "Usage:"
    echo "  $0 -s <SITEMAP_URL>    # Fetch & submit URLs from sitemap"
    echo "  $0 -p <PAGE_URL>       # Fetch & submit URLs from a page"
    echo "  $0 -u <URL>            # Submit a single URL"
    echo "  $0 -f <FILE>           # Submit bulk URLs from a file"
    exit 1
fi