Docker container hosting a Cantaloupe instance for the [Illinois Digital
Library Service](https://digital.library.illinois.edu/).

# Instance Overview

* Cantaloupe runs in standalone mode, using its embedded web server listening
  on HTTP port 8182.
* The source is S3Source and its lookup strategy is `ScriptLookupStrategy`.
* Identifiers are Medusa file UUIDs. The S3Source delegate method calls the
  DLS public HTTP API to look up their S3 object keys.
* The derivative cache is S3Cache.

# Build

1. Look at the comment header of `image_files/cantaloupe.properties` to see
   what version it's for.
2. Download that version's
   [release zip file](https://github.com/medusa-project/cantaloupe/releases)
   into `image_files`.
    * This could be automated, but doing it this way makes it easier to use
      arbitrary snapshots.
    * Of course, you can use any version, as long as the config file contains
      the right keys for it.
3. Copy `env.list.sample` to `env.list` and fill it in.
4. `./docker-build.sh`

# Run

## Locally

1. `./docker-run.sh`
2. Cantaloupe is listening at `http://localhost:8182`.

## In ECS

Note that in ECS, `env.list` isn't used at all. All of the variables it
contains have to be set in the task definition.

1. `./ecr-push.sh`
2. `./ecs-deploy.sh`
3. Check the status via the AWS web console or `./ecs-status.rb`.
