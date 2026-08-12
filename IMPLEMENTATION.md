# Recreate Thumbnails Implementation

## Summary

Issue: https://github.com/Madek/Madek/issues/920

The admin MediaFile detail page now activates the existing
`Recreate Thumbnails` button for MediaFiles whose previews can be generated
internally: images and PDF documents.

The recreation flow is intentionally direct:

1. Capture existing `Preview` ids and file paths.
2. Delete the existing preview rows with a checked `delete_all` inside a
   transaction.
3. Delete only the files that belonged to those old preview rows.
4. Call `MediaFile#create_previews!` to generate new preview rows and files.

## Modified Module

`admin-webapp` and its datalayer were changed.

Changed files:

- `admin-webapp/config/routes.rb`
- `admin-webapp/app/controllers/media_files_controller.rb`
- `admin-webapp/app/views/media_files/show.html.haml`
- `admin-webapp/spec/controllers/media_files_controller_spec.rb`
- `admin-webapp/datalayer/app/models/media_file.rb`
- `admin-webapp/datalayer/spec/models/media_file/media_file_spec.rb`

## Route

`admin-webapp/config/routes.rb` adds a member route:

```ruby
post :recreate_thumbnails, on: :member
```

This creates the path helper:

```ruby
recreate_thumbnails_media_file_path(@media_file)
```

## Controller Flow

`MediaFilesController#recreate_thumbnails`:

- Loads the MediaFile by `params[:id]`.
- Allows recreation only when `media_file.previews_internal?` is true.
- Deletes old preview rows with a checked `delete_all` inside an ActiveRecord
  transaction.
- Deletes only the old preview file paths captured before the row deletion.
- Generates new preview rows and files after old rows and files are gone.
- Redirects back to the MediaFile show page with an info or error flash.

Unsupported media files are rejected with an error flash. This includes audio,
video, and non-PDF document files.

### Failure Behavior

If old preview rows cannot be deleted, the transaction is rolled back and the old
thumbnail files are still present because files are deleted only after successful
row deletion.

If old file deletion fails because a file is already missing (`Errno::ENOENT`),
the storage is mounted read-only (`Errno::EROFS`), or the process lacks
permission to delete the file (`Errno::EACCES`, `Errno::EPERM`), the error is
logged and recreation continues. This matches the existing `Preview#after_destroy`
behavior, where file deletion errors are intentionally ignored and logged.

The read-only case can happen when the admin process runs against a production
attachment mount such as `/opt/madekdata/attachments` without write access. In
that case, old thumbnail files may remain on disk. Preview rows are still
recreated on the first trigger, but true replacement of the physical thumbnail
files still requires writable storage. If the storage remains read-only, existing
files may be reused or conversion may fail silently because `FileConversion`
does not currently check the ImageMagick exit status.

Unexpected file deletion failures (any error other than the four listed above)
still stop the request before generating new previews and show an error flash.

**Non-atomic trade-off (intentional):** The recreation flow deletes old preview
rows and files *before* calling `create_previews!`. If `create_previews!` raises
(e.g. a transient conversion error), the media file is left with zero previews
until the action is retried successfully. This is an intentional trade-off for an
admin-only tool: the old thumbnail filenames must be freed before recreation can
reuse them. The error flash message informs the admin to retry the action.
See also: https://github.com/Madek/Madek/issues/920

## Button Behavior

The button lives in:

`admin-webapp/app/views/media_files/show.html.haml`

For supported MediaFiles, it now submits a POST request with a confirmation
message. For unsupported MediaFiles, it remains disabled.

## Existing Datalayer Behavior Used

`MediaFile#previews_internal?` currently returns true for:

```ruby
image? or pdf?
```

`MediaFile#create_previews!` accepts a `thumbnail_profiles:` keyword so callers
can choose which thumbnail sizes to generate.

Images and PDF documents recreate all active thumbnail sizes:

- `maximum`
- `grand`
- `x_large`
- `large`
- `medium`

`Preview#after_destroy` still deletes a preview's file in normal destroy flows,
but thumbnail recreation uses `delete_all` for old rows so row rollback can keep
old files intact until deletion has succeeded.

## Tests

Controller specs were added for:

- Supported image media files recreate all active thumbnail profiles.
- Supported PDF media files recreate all active thumbnail profiles.
- Unsupported media files: existing previews remain and no recreation is
  attempted.
- Existing active thumbnails are deleted and regenerated.
- Old preview row deletion failures roll back the database work and keep old
  files.
- Old file deletion failures stop before generating new previews.
- Read-only old thumbnail file deletion is logged and does not block preview row
  recreation.
- Redirect and flash behavior.

Verification performed:

- Ruby syntax checks passed.
- HAML parse check passed.
- IDE diagnostics reported no linter errors.

The targeted RSpec command could not complete locally because Bundler `2.4.19`
is missing:

```text
Could not find 'bundler' (2.4.19) required by admin-webapp/Gemfile.lock.
```
