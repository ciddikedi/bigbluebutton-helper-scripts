require 'yaml'


class FileQueue
	
  def initialize(file_name)
    @file_name = file_name
  end

  def push(obj)
    safe_open('a') do |file|
      file.write(obj + "\n")
    end
  end

  alias << push
	
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

  def length
    count = 0
    safe_open('r') do |file|
      count = file.read.count("\n")
    end
    count
  end

  def empty?
    return length == 0
  end

  def clear
    safe_open('w') do |file| end
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
host = props['playback_host']

while !File.zero?("/var/bigbluebutton/queue_mp4.txt") do
  meetingId = queue.pop
  puts meetingId
  system("docker run -v /var/bigbluebutton/record-mp4:/root/records bedrettinyuce/bbb-recorder node export.js \"https://" + host + "/playback/presentation/2.0/playback.html?meetingId=" + meetingId + "\"" + " meeting.webm 0 true")
  if(File.exist?("/var/bigbluebutton/record-mp4/meeting.mp4"))
    File.rename("/var/bigbluebutton/record-mp4/meeting.mp4", "/var/bigbluebutton/record-mp4/" + meetingId + ".mp4")
  end
end
puts "ended"
