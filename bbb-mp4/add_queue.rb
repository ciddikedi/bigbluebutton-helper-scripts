#!/usr/bin/ruby

require 'optparse'

meeting_id = nil
OptionParser.new do |opts|
  opts.on('-m', '--meeting-id MEETING_ID', 'Internal Meeting ID') do |v|
    meeting_id = v
  end
  opts.on('-f', '--format FORMAT', 'Recording Format') do |v|
  end
end.parse!

unless meeting_id
  msg = 'Meeting ID was not provided'
  puts(msg) && raise(msg)
end

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

queue.push meeting_id