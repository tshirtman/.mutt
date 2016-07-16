#!/bin/sh
set -e

# Specific hooks set global configuration values for Mutt, which are not
# reset for new messages, so a default hook is needed to set the default
# value (do not try encrypting all messages).
printf "send-hook . unset crypt_autoencrypt\n"

# Generate a machine-readable list of known keys
gpg2 --batch --with-colons --list-keys \
    | awk -- '
        BEGIN {
            FS = ":"
            # A flag that indicates whether or not we are in a key with
            # usable encryption capability
            usable = 0
        }

        # Detect beginning of public keys with usable encryption
        # capability (E in the last field)
        $1 == "pub" && $12 ~ /E/ { usable = 1 }

        # Detect beginning of public keys without usable encryption
        # capability (no E in the last field)
        $1 == "pub" && $12 !~ /E/ { usable = 0 }

        # Only consider user IDs from keys with usable encryption capability
        # and with regular, marginal, full or ultimate validity
        # (n, m, f or u in the second field)
        usable && $1 == "uid" && $2 ~ /[nmfu]/ && $10 ~ /@/ {
            # Remove everything before and after the email address in brackets
            sub(/^[^<]*</, "", $10)
            sub(/>[^>]*$/, "", $10)
            # Finally print the email address
            print $10
        }' \
    | sort -u \
    | while read address
    do
        # Build a hook to try encrypting messages sent to each address
        printf "send-hook \"~t '%s'\" set crypt_autoencrypt\n" \
            "$address"
    done
