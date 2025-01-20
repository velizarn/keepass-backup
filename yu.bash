#!/bin/bash

# https://yandex.ru/dev/disk/poligon
# ./yu.bash OAuthToken "path-to-local-file" "remotefilename"

token=$1
localFile=$2
dbFile=$3

json=`curl -X GET --header 'Content-Type: application/json' --header 'Accept: application/json' --header "Authorization: OAuth $token" 'https://cloud-api.yandex.net/v1/disk/resources/upload' -G -d "path=disk:/testkdb/$dbFile" -d "overwrite=true"`

href=$(echo "$json" | sed -nE 's/.*"href":"([^\"]*)",".*/\1/p')

echo $href

curl -X PUT -T "$localFile" --header "Authorization: OAuth $token"  "$href"
