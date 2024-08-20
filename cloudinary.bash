#!/bin/bash

# ------------------------------
# Input parameters
fileName=$1
dbName=$2
cloudName=$3
apiKey=$4
apiSecret=$5
folder=${6:-""}
# ------------------------------

timestamp=$(date +%s)

publicId=$(basename $fileName)
publicId=${2:-$publicId}

if [ ! -z $folder ]; then
  folderStr="folder=${folder}"
else
  folderStr=""
fi

datatobehashed="access_mode=authenticated&${folderStr}&public_id=${publicId}&timestamp=${timestamp}$apiSecret"

hash=$(echo -n ${datatobehashed} | sha1sum | awk '{print $1}')

commandArr=()
commandArr+=("curl -s -X POST https://api.cloudinary.com/v1_1/${cloudName}/auto/upload")
commandArr+=("-F \"file=@${fileName}\"")
commandArr+=("-F \"access_mode=authenticated\"")
commandArr+=("-F \"public_id=${publicId}\"")
if [ ! -z $folder ]; then
  commandArr+=("-F \"${folderStr}\"")
fi
commandArr+=("-F \"api_key=${apiKey}\"")
commandArr+=("-F \"timestamp=${timestamp}\"")
commandArr+=("-F \"signature=${hash}\"")
commandArr+=("> /dev/null")

commandStr="${commandArr[@]}"

eval $commandStr

exit 0