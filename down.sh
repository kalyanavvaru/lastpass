#!/bin/bash
output=$(lpass ls SSH | tail -n +2) 
#echo "$output"
pat='SSH\/(.*?) \[id: (.*?)\]'
lpass_ssh_keys=()

while read -r line; do 
	[[ "$line" =~ $pat ]] 
	#echo "$line"
	#echo "${BASH_REMATCH[0]}" 
	# echo "${BASH_REMATCH[1]}" 
	
	lpass_ssh_keys+=( $(echo "$line" | sed -E 's/^SSH\/(.*) \[.*/\1/') )
	#echo "${BASH_REMATCH[2]}" 
done <<< $output

echo -e "\nBelow are the SSH keys stored in Lastpass. Select which one to download \n (you can choose the name when prompted)?"
select selected_lpass_key in "${lpass_ssh_keys[@]}"; do
        [ -n "${selected_lpass_key}" ] && break
done
echo "You selected: ${selected_lpass_key}...downloading from your lastpass account"



keyname="$(lpass ls SSH | sed -n '2 p' |  tr -s " " "\012" | head -n 1 | cut -d'/' -f2)"
privateKey=$(lpass show "SSH/dxclaptop" --field="Private Key")
publicKey=$(lpass show "SSH/dxclaptop" --field="Public Key")
 
echo "Saving as ~/.ssh/${selected_lpass_key} and ~/.ssh/${selected_lpass_key}.pub: Type to override: "
read override_keyname;

if [[ $override_keyname = *[!\ ]* ]]; then
  selected_lpass_key=$override_keyname
fi
echo "Saving as ~/.ssh/${selected_lpass_key} and ~/.ssh/${selected_lpass_key}.pub"
read -p "Press enter to continue"
echo $privateKey > ~/.ssh/${selected_lpass_key}
echo $publicKey > ~/.ssh/${selected_lpass_key}.pub
echo "Here are the new keys listed\n"
ls -al ~/.ssh/$selected_lpass_key*
