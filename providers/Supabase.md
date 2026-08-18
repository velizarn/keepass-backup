## Upload backup file to Supabase Storage S3

### Initial requirements

Before using Supabase Storage S3-Compatible API, you require:

- An active Supabase account. [Sign up here](https://supabase.com/dashboard/sign-up) if you do not have one.
- A bucket in Supabase Storage. See [how to create a bucket](https://supabase.com/docs/guides/storage/buckets/creating-buckets).
- Valid Access Key ID and Secret Access Key. Learn how to [create an access key](https://supabase.com/docs/guides/storage/s3/authentication).

### File upload/download via HTTP request

Because Supabase Storage fully supports AWS Signature Version 4, you can use curl's native --aws-sigv4 parameter in the exact same fashion as Cloudflare R2 or AWS S3.

Upload file:

```sh
curl -X PUT "https://PROJECT_ID.storage.supabase.co/storage/v1/s3/BUCKET_NAME/my_file.ext" \
  --aws-sigv4 "aws:amz:auto:s3" \
  --user "ACCESS_KEY_ID:SECRET_ACCESS_KEY" \
  --upload-file "/path/to/local/my_file.ext"
```
Where `https://PROJECT_ID.storage.supabase.co/storage/v1/s3` is the endpoint you can find on *S3 Configuration > Connection* section in [your account](https://supabase.com/docs/guides/storage/s3/authentication).


Download file:

```sh
curl "https://PROJECT_ID.storage.supabase.co/storage/v1/s3/BUCKET_NAME/my_file.ext" \
  --aws-sigv4 "aws:amz:auto:s3" \
  --user "ACCESS_KEY_ID:SECRET_ACCESS_KEY" \
  -o "/path/to/local/my_file.ext"
```

### Resources

- [Supabase Storage - Create bucket](https://supabase.com/docs/guides/storage/buckets/creating-buckets)
- [Supabase Storage - S3 Authentication](https://supabase.com/docs/guides/storage/s3/authentication)
- [Supabase Storage - S3 Uploads](https://supabase.com/docs/guides/storage/uploads/s3-uploads)
