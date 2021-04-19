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

queue.push ARGV[1]
