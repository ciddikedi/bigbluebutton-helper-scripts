#!/usr/bin/ruby

require 'yaml'
require 'rubygems'
require 'aws-sdk-s3'
require 'fileutils'

if !Dir.exist?('/var/bigbluebutton/record_mp4')
  FileUtils.mkdir_p '/var/bigbluebutton/record_mp4'
  FileUtils.mkdir_p '/var/bigbluebutton/record_mp4/log'
  FileUtils.mkdir_p '/var/bigbluebutton/record_mp4/temp'
  FileUtils.mkdir_p '/var/bigbluebutton/record_mp4/uploaded'
end

class FileQueue
  def initialize(file_name)
    @file_name = file_name
  end
  def pop
    value = nil
    rest = nil
    safe_open('r') do |file|
      value = file.gets
      rest = file.read
    end
    safe_open('w+') do |file|
      file.write(rest)
    end
    value
  end	
  private
  def safe_open(mode)
    File.open(@file_name, mode) do |file|
      file.flock(File::LOCK_EX)
      yield file
      file.flock(File::LOCK_UN)
    end
  end
end

queue = FileQueue.new '/var/bigbluebutton/queue_mp4.txt'
props = YAML::load(File.open('/usr/local/bigbluebutton/core/scripts/bigbluebutton.yml'))
creds = YAML::load(File.open('/usr/local/bigbluebutton/core/scripts/s3_creds.yml'))
host = props['playback_host']
endpoint = creds['endpoint']
access_key_id = creds['access_key_id']
secret_access_key = creds['secret_access_key']
bucket = creds['bucket']
region = creds['region']
playback = creds['playback_server']
s3Client = Aws::S3::Client.new(endpoint: endpoint, access_key_id: access_key_id, secret_access_key: secret_access_key, region: region)
s3Resource = Aws::S3::Resource.new(client: s3Client)
bucketObj = s3Resource.bucket(bucket)

while !File.zero?("/var/bigbluebutton/queue_mp4.txt") do
  meetingId = queue.pop
  puts meetingId
  logfile =  "/var/bigbluebutton/record_mp4/log/#{meetingId}.log"
  pid = spawn("docker run -v /var/bigbluebutton/record_mp4/temp:/root/records bedrettinyuce/bbb-recorder node export.js \"" + playback + "/playback/presentation/2.0/playback.html?meetingId=" + meetingId + "\"" + " meeting.webm 0 true", [:err] => logfile)
  Process.wait(pid)
  if(File.exist?("/var/bigbluebutton/record_mp4/temp/meeting.mp4"))
    File.rename("/var/bigbluebutton/record_mp4/temp/meeting.mp4", "/var/bigbluebutton/record_mp4/temp/" + meetingId + ".mp4")
  end
  file_name = '/var/bigbluebutton/record_mp4/temp/' + meetingId + '.mp4'
  key = File.basename(file_name)
  puts "Uploading file #{file_name} to bucket #{bucket}..."
  s3Client.put_object(
    :bucket => bucket,
    :key    => bucket + '/' + key,
    :body   => IO.read(file_name),
    :acl    => 'public-read'
  )
  if(bucketObj.object(bucket + '/' + meetingId + '.mp4').exists?)
    File.delete('/var/bigbluebutton/record_mp4/temp/' + meetingId + '.mp4')
    FileUtils.touch('/var/bigbluebutton/record_mp4/uploaded/' + meetingId + '.done')
  end
end
puts "ended"
