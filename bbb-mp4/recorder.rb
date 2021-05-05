#!/usr/bin/ruby

require 'yaml'
require 'rubygems'
require 'aws-sdk-s3'


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

while !File.zero?("/var/bigbluebutton/queue_mp4.txt") do
  meetingId = queue.pop
  puts meetingId
  system("docker run -v /var/bigbluebutton/record-mp4:/root/records bedrettinyuce/bbb-recorder node export.js \"https://" + host + "/playback/presentation/2.0/playback.html?meetingId=" + meetingId + "\"" + " meeting.webm 0 true")
  if(File.exist?("/var/bigbluebutton/record-mp4/meeting.mp4"))
    File.rename("/var/bigbluebutton/record-mp4/meeting.mp4", "/var/bigbluebutton/record-mp4/" + meetingId + ".mp4")
  end
end
file_name = '/var/bigbluebutton/record-mp4/' + meetingId + '.mp4'

s3 = Aws::S3::Client.new(endpoint: endpoint, access_key_id: access_key_id, secret_access_key: secret_access_key, region: region)

key = File.basename(file_name)

puts "Uploading file #{file_name} to bucket #{bucket}..."

s3.put_object(
  :bucket => bucket,
  :key    => bucket + '/' + key,
  :body   => IO.read(file_name),
  :acl    => 'public-read'
)
puts "ended"