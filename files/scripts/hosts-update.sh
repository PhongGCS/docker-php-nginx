#!/bin/bash

DOMAINS=( $(docker ps --format '{{.Names}}' | grep _web | sed 's/_web//g' | sed 's/_/\./g') )
IP_ADDRESSES=( $(docker ps | grep _web | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:80' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'))


LEAD='### BEGIN LOCAL DEV HOSTS'
TAIL='### END LOCAL DEV HOSTS'
HOSTS_FILE='/etc/hosts'
TMP_FILE='./hosts.tmp'



if [ ! -z "$(grep "$LEAD" "$HOSTS_FILE")" ]; then
    sed "/$LEAD/,/$TAIL/d" $HOSTS_FILE > $TMP_FILE
fi

# recreate the section
echo "" >> $TMP_FILE
echo $LEAD >> $TMP_FILE

HOSTS_UPDATE=""
for i in "${!DOMAINS[@]}"
do
	echo ${IP_ADDRESSES[$i]}$'\t'${DOMAINS[$i]} >> $TMP_FILE
done

echo $TAIL >> $TMP_FILE

sudo mv "$TMP_FILE" /etc/hosts