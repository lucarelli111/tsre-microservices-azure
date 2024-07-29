#!/bin/bash

# Function to extract header value
extract_header_value() {
    local headers="$1"
    local header_name="$2"
    echo "$headers" | grep -i "$header_name" | awk '{print $2}' | tr -d '\r'
}
# Get Authentication Token
TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)

# Get Data we need
RESPONSE=$(curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest)
echo $RESPONSE

# Extract RateLimit-Limit and RateLimit-Remaining
LIMIT=$(extract_header_value "$RESPONSE" "RateLimit-Limit")
REMAINING=$(extract_header_value "$RESPONSE" "RateLimit-Remaining")

# Check if the values are correctly extracted
if [ -z "$LIMIT" ] || [ -z "$REMAINING" ]; then
  echo "Failed to retrieve rate limit information. Please check your network connection or try again later."
  exit 1
fi

# Output the result
echo "Rate limit: $LIMIT pulls per 6 hours."
echo "Remaining pulls: $REMAINING"