#!/bin/bash
echo -e "\n\n 1. which local ssh key to add? (for e.g ~/.ssh/id_rsa, enter id_rsa)"; \
read keyname; \
echo -e "\n3. last pass item name? "; \
read itemname; \
printf "Private Key: %s\nPublic Key: %s" \
"$(cat ~/.ssh/$keyname)" "$(cat ~/.ssh/$keyname.pub)"| \
lpass add --non-interactive --sync=now "SSH/${itemname}" --note-type=ssh-key
