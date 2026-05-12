#! /bin/bash
#This script will brute force domain names
#Prompt to user to enter the domain name
read -p "Enter the domain name that you want to brute-force: " DOMAIN_NAME
function check_domain(){
#Execute the host command and extract the live subdomains
results=$(host $SUB_DOMAIN | grep 'has address')
#if not empty results
if [[ -n $results ]]
then
printf "Found $SUB_DOMAIN\n"
fi
}
#read the dictionary file
for sub in $(cat sub-d.txt)
do
SUB_DOMAIN=$sub.$DOMAIN_NAME
check_domain
done
