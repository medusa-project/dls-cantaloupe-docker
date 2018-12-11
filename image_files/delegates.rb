##
# This file is for Cantaloupe 4.1-SNAPSHOT as of 2018-12-06.
#

require 'json'

java_import java.net.HttpURLConnection
java_import java.net.URL
java_import java.io.BufferedReader
java_import java.io.FileNotFoundException
java_import java.io.InputStreamReader
java_import java.util.Base64
java_import java.util.stream.Collectors

class CustomDelegate

  attr_accessor :context

  def authorize(options = {})
    true
  end

  def extra_iiif2_information_response_keys(options = {})
    {}
  end

  def source(options = {})
  end

  def azurestoragesource_blob_key(options = {})
  end

  def filesystemsource_pathname(options = {})
  end

  def httpsource_resource_info(options = {})
  end

  def jdbcsource_database_identifier(options = {})
  end

  def jdbcsource_media_type(options = {})
  end

  def jdbcsource_lookup_sql(options = {})
  end

  def s3source_object_info(options = {})
    identifier = context['identifier']

    # This is used for a demo at https://medusa-project.github.io/cantaloupe/
    if identifier == 'andromeda-pyramidal-tiled.tif'
      return {
          'bucket' => ENV['CANTALOUPE_S3SOURCE_BUCKET_NAME'],
          'key' => identifier
      }
    end

    url = URL.new(ENV['MEDUSA_URL'] + '/uuids/' +
        URI.escape(identifier) + '.json')

    conn, is, reader = nil
    begin
      conn = url.openConnection
      conn.setRequestMethod 'GET'
      conn.setReadTimeout 30 * 1000
      conn.setRequestProperty('Authorization', 'Basic ' + encoded_credential)
      conn.connect
      is = conn.getInputStream
      status = conn.getResponseCode

      if status == 200
        reader = BufferedReader.new(InputStreamReader.new(is))
        entity = reader.lines.collect(Collectors.joining("\n"))
        return {
          'bucket' => ENV['CANTALOUPE_S3SOURCE_BUCKET_NAME'],
          'key' => JSON.parse(entity)['relative_pathname'].reverse.chomp('/').reverse
        }
      else
        raise IOError, "Unexpected response status: #{status}"
      end
    rescue FileNotFoundException => e
      return nil
    rescue => e
      Java::edu.illinois.library.cantaloupe.script.Logger.warn("#{e}")
    ensure
      reader&.close
      is&.close
      conn&.disconnect
    end
  end

  def encoded_credential
    Base64.getEncoder.encodeToString(
        (ENV['MEDUSA_USER'] + ':' + ENV['MEDUSA_SECRET']).bytes)
  end

  def overlay(options = {})
  end

  def redactions(options = {})
    []
  end

end
