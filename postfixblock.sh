#!/bin/bash

whitelist=(email1@example.com email2@example.com
for OUTPUT in $(cat /var/log/maillog  | grep deferred | sed -n 's/.*to=<\(.*\)>.*/\1/p' | sort | uniq)
do
        if cat /etc/postfix/transport | grep -q "^$OUTPUT"; then
                echo "Skipping $OUTPUT"
        else
                if [[ " ${whitelist[@]} " =~ " ${OUTPUT} " ]]; then
                        echo "skipping $OUTPUT due to whitelist"
                else
                        echo "Adding $OUTPUT to blocklist"
                        echo "$OUTPUT" >> /etc/postfix/transport
                fi
        fi
done
postmap /etc/postfix/transport
service postfix reload
