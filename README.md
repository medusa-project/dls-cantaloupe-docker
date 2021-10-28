Docker container hosting a Cantaloupe instance for the [Illinois Digital
Library Service](https://digital.library.illinois.edu/).

# Instance Overview

* Cantaloupe listens on HTTP port 8182.
* AWS credentials are obtained from a task IAM role. When running locally,
  these are obtained from an [ECS Local Endpoint](https://aws.amazon.com/blogs/compute/a-guide-to-locally-testing-containers-with-amazon-ecs-local-endpoints-and-docker-compose/).
* There are three supported identifier schemes:
    1. Medusa file UUIDs. The S3Source delegate method calls the Medusa HTTP
       API to look up their object keys.
    2. Full S3 URLs (`s3://...`).
    3. Strings starting with `v/` are video thumbnails for which `HttpSource`
       is used to get an image from [Kaltura](https://mediaspace.illinois.edu),
       because of `FfmpegProcessor` limitations (see below). There are a very
       small number of these.
* The source for all Medusa content is S3Source and its lookup strategy is
  `ScriptLookupStrategy`.
* The derivative cache is S3Cache.
* Format assignments:
    * JPEG: TurboJpegProcessor
    * JPEG2000: KakaduNativeProcessor
    * PDF: PdfBoxProcessor
    * Videos: FfmpegProcessor (which works very poorly with non-filesystem
      storage, so serving video stills is not advised)
    * Everything else: Java2dProcessor

# Build

1. Look at the comment header of `image_files/cantaloupe.properties` to see
   what version it's for.
2. Download that version's
   [release zip file](https://github.com/medusa-project/cantaloupe/releases)
   into `image_files`.
    * Of course, you can use any version, as long as the config file contains
      the right keys for it, and any dependencies are in place.
    * This could be automated, but doing it this way makes it easier to use
      arbitrary snapshots.
3. Copy `env.list.sample` to `env.list` and fill it in. **Don't commit it to
   version control!**
4. `./docker-build.sh`

# Run

## Locally

1. `aws login` ([GitHub](https://github.com/techservicesillinois/awscli-login))
2. `docker-compose up --build`

It's now listening at `http://localhost:8182`.

## In ECS

In ECS, `env.list` isn't used, so all of its variables have to be set in
the task definition.

1. `./ecr-push.sh`
2. `./ecs-deploy.sh`
3. Check the status via the AWS web console or `./ecs-status.rb`.

# ECS Configuration Notes

Images are tagged with the Cantaloupe version. There is also a `latest` tag
applied to the latest version which is what is specified in the task
definition. If there is ever a need to revert to a previous version, the
task definition must be updated (in Terraform) to specify that version.
