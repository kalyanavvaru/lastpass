# lastpass
lastpass commands to pull and add to ssh keys
## install lastpass cli
apt-get install lastpass-cli

# login to your lastpass account
lpass login <your_email@your_email_server>

# add your local ssh with optional passphrase
echo -e "\n\n 1. which local ssh key to add? (for e.g ~/.ssh/id_rsa, enter id_rsa)"; \
read keyname; \
echo -e "\n3. last pass item name? "; \
read itemname; \
printf "Private Key: %s\nPublic Key: %s" \
"$(cat ~/.ssh/$keyname)" "$(cat ~/.ssh/$keyname.pub)"| \
lpass add --non-interactive --sync=now "SSH/${itemname}" --note-type=ssh-key

# pull the ssh key from lastpass and add to local ssh
echo -e "\n\n 1. which local ssh key to add? (for e.g ~/.ssh/id_rsa, enter id_rsa)"; \
read keyname; \
echo -e "\n3. last pass item name? "; \
read itemname; \
printf "Private Key: %s\nPublic Key: %s" \
"$(cat ~/.ssh/$keyname)" "$(cat ~/.ssh/$keyname.pub)"| \
lpass add --non-interactive --sync=now "SSH/${itemname}" --note-type=ssh-key

# list of keys
#!/bin/bash

output=$(lpass ls SSH | tail -n +2)
#echo "$output"
pat='SSH\/(.*?) \[id: (.*?)\]'

while read -r line; do
        [[ "$line" =~ $pat ]]
        #echo "$line"
        #echo "${BASH_REMATCH[0]}"
        echo "${BASH_REMATCH[1]}"
        #echo "${BASH_REMATCH[2]}"
done <<< $output

# export as keys
keyname="$(lpass ls SSH | sed -n '2 p' |  tr -s " " "\012" | head -n 1 | cut -d'/' -f2)"
lpass show "SSH/dxclaptop" --field="Private Key" > ~/.ssh/$keyname
lpass show "SSH/dxclaptop" --field="Public Key" > ~/.ssh/$keyname.pub
