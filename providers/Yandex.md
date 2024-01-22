## Upload backup file to Yandex Disk

**Example script**

```sh
#!/bin/bash

# ./yu.bash <fileToUpload> <dbFileName> <api_token> <folder>

EXPECTED_ARGS=4
if [ "$#" -ne "$EXPECTED_ARGS" ]; then
    echo "Error: Invalid number of arguments."
    echo "Expected $EXPECTED_ARGS, but got $#."
    echo "Usage: <fileToUpload> <dbFileName> <api_token> <folder>"
    exit 1
fi

localFile=$1
dbFile=$2
token=$3
folder=$4

if [ ! -z $folder ]; then
  remotePath="${folder}/${dbFile}"
else
  remotePath="${dbFile}"
fi

json=`curl -X GET \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: OAuth $token" \
  'https://cloud-api.yandex.net/v1/disk/resources/upload' \
  -G \
  -d "path=disk:/$remotePath" \
  -d "overwrite=true"`

href=$(echo "$json" | sed -nE 's/.*"href":"([^\"]*)",".*/\1/p')

echo $href

curl -X PUT -T "$localFile" --header "Authorization: OAuth $token"  "$href"
```

Go to https://yandex.ru/dev/disk/poligon and request an OAuth token.

### Resources

- https://yandex.com/dev/disk/
- [Yandex Disk Poligon](https://yandex.ru/dev/disk/poligon)
- [Yandex Disk API - Getting started](https://yandex.com/dev/disk/doc/en/concepts/quickstart)
- [Yandex Disk - GitHub](https://github.com/yandex-disk/)