#!/bin/bash

# Check if domain argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./zonetransfer.sh <domain.com>"
    exit 1
fi

DOMAIN=$1

echo "[+] Identifying Name Servers for $DOMAIN..."

# 1. Extract NS records and clean the output
# 'host -t ns' returns "domain.com name server ns1.example.com"
# 'cut -d " " -f 4' grabs the 4th column (the actual server name)
SERVERS=$(host -t ns $DOMAIN | cut -d " " -f 4)

if [ -z "$SERVERS" ]; then
    echo "[-] No Name Servers found. Check the domain name."
    exit 1
fi

# 2. Loop through each server and attempt AXFR
for NS in $SERVERS; do
    echo "[*] Attempting Zone Transfer on $NS..."
    
    # 'host -l' initiates an AXFR request
    # grep -v "failed" hides common error messages for a cleaner output
    RESULT=$(host -l $DOMAIN $NS | grep -v "failed")
    
    if [ ! -z "$RESULT" ]; then
        echo "[!] Success! Found records on $NS:"
        echo "$RESULT"
    else
        echo "[-] Transfer refused or failed on $NS."
    fi
    echo "------------------------------------------"
done
