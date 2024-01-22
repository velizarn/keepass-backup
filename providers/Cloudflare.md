## Upload backup file to Cloudflare R2

### Initial requirements

- Register a Cloudflare account and login https://dash.cloudflare.com/login <br />
Add R2 Object Storage as product available in your account.
- Create a bucket
- Create an Account API Token from R2 dashboard
  - Click Create API token
  - Permission: Admin Read & Write (or Object Read & Write)
  - Bucket scope: apply to specific bucket or all buckets
  - Click _Create_
  - Copy the "_Access Key ID_" and "_Secret Access Key_" (shown only once!)
- Add dedicated KeePass trigger for upload database file to Cloudflare R2 bucket

### File upload via HTTP request

Upload file:

```sh
curl -X PUT "https://ACCOUNT_ID.r2.cloudflarestorage.com/YOUR_BUCKET/file.txt" \
  --aws-sigv4 "aws:amz:auto:s3" \
  --user "ACCESS_KEY_ID:SECRET_ACCESS_KEY" \
  --upload-file "/path/to/local/file.txt"
```
For EU region change the URL to `ACCOUNT_ID.eu.r2.cloudflarestorage.com`.

R2 buckets are private by default. Public access requires explicitly enabling it via a Custom Domain or `r2.dev subdomain`. 
Since the file is uploaded via the S3 API and neither of these public access options is configured, the object remains private and can only be accessed through authenticated requests using the corresponding R2 API credentials.

Download file:

```sh
curl --user "ACCESS_KEY_ID:SECRET_ACCESS_KEY" \
  --aws-sigv4 "aws:amz:auto:s3" \
  https://ACCOUNT_ID.r2.cloudflarestorage.com/YOUR_BUCKET/file.txt \
  -o "/path/to/local/file.txt"
```

### Resources

- [Cloudflare R2 - Developers](https://developers.cloudflare.com/r2/)
- [Cloudflare R2 - API tokens](https://developers.cloudflare.com/r2/api/tokens/)
