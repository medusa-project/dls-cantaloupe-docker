Docker container hosting a Cantaloupe instance for the [Illinois Digital
Library Service](https://digital.library.illinois.edu/).

# Instance Overview

* Cantaloupe runs in standalone mode, using its embedded web server listening
  on HTTP port 8182.
* AWS credentials are obtained from a task IAM role. When running locally,
  these are obtained from an [ECS Local Endpoint](https://aws.amazon.com/blogs/compute/a-guide-to-locally-testing-containers-with-amazon-ecs-local-endpoints-and-docker-compose/).  
* Identifiers are Medusa file UUIDs. The S3Source delegate method calls the
  Medusa HTTP API to look up their S3 object keys.
* The source for all Medusa content is S3Source and its lookup strategy is
  `ScriptLookupStrategy`.
    * There are also a very small number of videos for which `HttpSource` is
      used to get an image from [Kaltura](https://mediaspace.illinois.edu),
      because of `FfmpegProcessor` limitations (see below).
* The derivative cache is S3Cache.
* Format assignments:
    * JPEG: TurboJpegProcessor
    * JPEG2000: KakaduNativeProcessor
    * PDF: PdfBoxProcessor
    * Videos: FfmpegProcessor (which doesn't work well with non-filesystem
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
