## Upload backup file to Dropbox

### Initial requirements

1) Register a Dropbox account and login

2) Create Dropbox API key

Go to Dropbox [App Console](https://www.dropbox.com/developers/apps) and create a new App with Scoped access: 
- Select App Folder - this gives access to a single folder created specifically for your app.
- Name your app...
- After new app is created
	- Go to **Settings** tab > **Generated Access Token** and click "*Generate*" CTA - By generating an access token, you will be able to make API calls for your own account without going through the authorization flow. To obtain access tokens for other users, use the standard OAuth flow. 
	- For scoped apps, the token will have the same scope as the app. You dont't need API Key and the API Secret, the token will be enough.
	- Go to **Permissions** tab and choose the type of access you need - make sure the `files.content.write` scope is checked. It is recommended that you regenerate the access token every time you update the scope of the App.
  ![App permissions](./dropbox_app.png)

3) Create a dedicated KeePass entry in your database/s (e.g. `DO-NOT-DELETE-DBOX`) to hold Dropbox Access Token and folder used in cUrl script executed by KeePass trigger.

4) Add dedicated KeePass trigger for Dropbox Upload

### File upload via HTTP request

Request:

```sh
curl -X POST https://content.dropboxapi.com/2/files/upload \
  --header "Authorization: Bearer __YOUR_GENERATED_ACCESS_TOKEN__" \
  --header "Dropbox-API-Arg: {\"autorename\":false,\"mode\":\"overwrite\",\"mute\":true,\"path\":\"/testkdb/Database-2.kdbx\"}" \
  --header "Content-Type: application/octet-stream" \
  --data-binary @"C:/path/to/kdbx-file/Database-2.kdbx"
 ```

Sample response:

```json
{
  "name": "Database-2.kdbx",
  "path_lower": "/testkdb/database-2.kdbx",
  "path_display": "/testkdb/Database-2.kdbx",
  "id": "id:x6sMmJ4Ev9BhLG4Y97Ump9",
  "client_modified": "2026-08-14T13:51:40Z",
  "server_modified": "2026-08-14T13:51:40Z",
  "rev": "F9BHVquVSs6eKKR7zHWuRftQjCQ3hCh",
  "size": 4467,
  "is_downloadable": true,
  "content_hash": "bSsD2h7zxQtPrcg5GvSUxCdjgyCb8RHRbSsD2h7zxQtPrcg5GvSUxCdjgyCb8RHR"
}
```

File is uploaded to a dedicated folder inside Apps main folder in your Dropbox account.<br />
Files uploaded to an App Folder are NOT publicly accessible by default. They are private and secure.

### Resources

- https://www.dropbox.com/
- [Dropbox for Developers](https://www.dropbox.com/developers/apps)
- [Ddropbox API File upload](https://www.dropbox.com/developers/documentation/http/documentation#files-upload)
- [StackOverflow Dropbox questions](https://stackoverflow.com/questions/tagged/Dropbox)