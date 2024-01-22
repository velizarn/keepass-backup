## Upload backup file to Koofr

### Initial requirements

1) **Register** a Koofr account and login https://app.koofr.net/

2) **Enable Two-Factor Authentication** for your account by using Authentication app and/or Passkey.

3) **Create an App password**
App passwords are used to access your files from other applications like WebDAV and/or API requests.

### File upload via HTTP request

Request:

```sh
#!/bin/bash

USERNAME=$1 # your Koofr login
PASSWORD=$2 # this is an App password
FILETOUPLOAD=$3
FOLDER=${4:-""}

BASEURL=https://app.koofr.net

PRIMARY=$(curl -u "$USERNAME:$PASSWORD" \
  "$BASEURL/api/v2/places" | \
  jq -r '.places | map(select(.isPrimary == true))[0].id')

curl -u "$USERNAME:$PASSWORD" \
  -X POST \
  -F "file=@$FILETOUPLOAD" \
  "$BASEURL/content/api/v2/mounts/$PRIMARY/files/put?path=/$FOLDER&info=true" | \
  jq .
```

Sample response:

```json
{
  "name": "newimage.jpg",
  "type": "file",
  "modified": 1786886505134,
  "size": 77306,
  "contentType": "image/jpeg",
  "hash": "9e435c2dc30f5d59ec279834ba3ffa7c",
  "tags": {}
}

```

To make sure that no one can access any of the files you upload, at least enable two-factor authentication (2FA) in your account preferences.

### Resources

- [Koofr - One storage for all](https://koofr.eu/)
- [Koofr @ GitHub](https://github.com/koofr)
- [Koofr API](https://app.koofr.net/developers)
- [Pricing](https://koofr.eu/pricing/)