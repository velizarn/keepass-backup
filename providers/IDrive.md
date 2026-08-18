## Upload backup file to IDrive e2

### Initial requirements

Before using IDrive e2 S3-Compatible API, you require:

- An active IDrive e2 account. [Sign up here](https://app.idrivee2.com/signup) if you do not have one.
- A bucket in IDrive e2. See [how to create a bucket](https://www.idrive.com/s3-storage-e2/faq-buckets#create_bucket).
- Valid Access Key ID and Secret Access Key. Learn how to [create an access key](https://www.idrive.com/s3-storage-e2/faq-access-keys#get_credentials).

### File upload/download via HTTP request

Because IDrive e2 fully supports AWS Signature Version 4, you can use curl's native --aws-sigv4 parameter in the exact same fashion as Cloudflare R2 or AWS S3.

Upload file:

```sh
curl -X PUT "https://BUCKET_NAME.s3.REGION_CODE.idrivee2.com/my_file.ext" \
  --aws-sigv4 "aws:amz:auto:s3" \
  --user "ACCESS_KEY_ID:SECRET_ACCESS_KEY" \
  --upload-file "/path/to/local/my_file.ext"
```

Download file:

```sh
curl "https://BUCKET_NAME.s3.REGION_CODE.idrivee2.com/file.ext" \
  --aws-sigv4 "aws:amz:auto:s3" \
  --user "ACCESS_KEY_ID:SECRET_ACCESS_KEY" \
  -o "/path/to/local/file.ext"
```

### Resources

- [IDrive e2 - Amazon S3 Compatibility](https://www.idrive.com/s3-storage-e2/compatibility)
- [IDrive e2 - S3 Compatible API](https://www.idrive.com/s3-storage-e2/s3-compatible-api)
- [IDrive e2 - Create bucket](https://www.idrive.com/s3-storage-e2/faq-buckets#create_bucket)
