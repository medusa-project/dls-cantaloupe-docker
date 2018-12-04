Docker container hosting a Cantaloupe instance for the [Illinois Digital Library](https://digital.library.illinois.edu/).

# Instance Overview

* Cantaloupe runs in standalone mode, using its embedded web server listening
  on HTTP port 8182.
* The source is S3Source and its lookup strategy is `ScriptLookupStrategy`.
* The derivative cache is S3Cache.

# Getting Started

1. Look at the comment header of `image_files/cantaloupe.properties` to see
   what version it's for.
2. Download that version's
   [release zip file](https://github.com/medusa-project/cantaloupe/releases)
   into `image_files`.
3. Copy `env.list.sample` to `env.list` and edit as necessary.
4. `./docker-build.sh`
5. `./docker-run.sh`
6. Cantaloupe is listening at `http://localhost:8182`.
