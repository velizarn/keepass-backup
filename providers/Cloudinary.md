
## Upload backup file to Cloudinary

### Example script

```sh
#!/bin/bash

EXPECTED_ARGS=6
if [ "$#" -ne "$EXPECTED_ARGS" ]; then
    echo "Error: Invalid number of arguments."
    echo "Expected $EXPECTED_ARGS, but got $#."
    echo "Usage: <fileToUpload> <dbFileName> <cloudName> <api_key> <api_secret> <remote_folder>"
    exit 1
fi

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
```

> [!NOTE]
> In general, it is not a good idea to upload non-media files to a CDN storage like Cloudinary even if you toggle a file to private/authenticated access. Cloudinary is explicitly an asset-management solution designed for web/app media (images, videos, PDFs, design files). Also CDNs are built for delivery and not a long-term storage.

### Resources

- [Cloudinary documentation](https://cloudinary.com/documentation)
- [Cloudinary API - Upload](https://cloudinary.com/documentation/image_upload_api_reference)
- [Cloudinary Admin API reference](https://cloudinary.com/documentation/admin_api#api_overview)
- [Cloudinary File upload using cUrl](https://support.cloudinary.com/hc/en-us/community/posts/360000183051-File-upload-using-curl)