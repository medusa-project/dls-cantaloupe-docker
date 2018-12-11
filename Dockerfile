FROM openjdk:11

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
  && rm -rf /var/lib/apt/lists/*

ARG home=/home/cantaloupe
RUN mkdir -p $home/tmp
WORKDIR $home

# Copy the compressed archive into the image and extract it
COPY ./image_files/cantaloupe-*.zip ./cantaloupe.zip
RUN unzip cantaloupe.zip
RUN rm cantaloupe.zip

# Install KakaduNativeProcessor dependencies
RUN mkdir -p /usr/local/bin /usr/local/lib
RUN cp cantaloupe-*/deps/Linux-x86-64/bin/* /usr/local/bin
RUN cp cantaloupe-*/deps/Linux-x86-64/lib/* /usr/local/lib
RUN mv cantaloupe-*/cantaloupe-*.war cantaloupe.war

COPY ./image_files/cantaloupe.properties ./cantaloupe.properties
COPY ./image_files/delegates.rb ./delegates.rb

# Mount the images bucket
RUN mkdir -p /bucket

ENTRYPOINT ["java", "-Dcantaloupe.config=cantaloupe.properties", \
    "-Djava.library.path=/usr/local/lib", \
    "-jar", "cantaloupe.war"]
