FROM openjdk:15-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    unzip \
  && rm -rf /var/lib/apt/lists/*

# Install TurboJpegProcessor dependencies
RUN mkdir -p /opt/libjpeg-turbo/lib
COPY ./image_files/libjpeg-turbo/lib64 /opt/libjpeg-turbo/lib

ARG home=/home/cantaloupe
RUN mkdir -p $home/tmp
WORKDIR $home

# Copy the compressed archive into the image and extract it
COPY ./image_files/cantaloupe-*.zip ./cantaloupe.zip
RUN unzip cantaloupe.zip && rm cantaloupe.zip

# Install KakaduNativeProcessor dependencies
RUN mkdir -p /usr/local/lib \
    && cp cantaloupe-*/deps/Linux-x86-64/lib/* /usr/local/lib \
    && mv cantaloupe-*/cantaloupe-*.jar cantaloupe.jar

COPY ./image_files/cantaloupe.properties ./cantaloupe.properties
COPY ./image_files/delegates.rb ./delegates.rb

# When you run the JVM in a container with no arguments,
# XX:MaxRAMPercentage (really heap size) defaults to 25, which is
# way too low. PDFBox in particular is a "hungry hungry heapo" that
# can easily consume all of that in a single request.
# But we also need to keep in mind that Kakadu does its work
# off-heap.
ENTRYPOINT ["java", "-Dcantaloupe.config=cantaloupe.properties", \
    "-Djava.library.path=/usr/local/lib", \
    "-XX:MaxRAMPercentage=65", \
    "-jar", "cantaloupe.jar"]
