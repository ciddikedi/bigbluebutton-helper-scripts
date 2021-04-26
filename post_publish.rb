#!/usr/bin/ruby
require 'fileutils'
require 'optparse'
require 'psych'

meeting_id = nil
OptionParser.new do |opts|
  opts.on('-m', '--meeting-id MEETING_ID', 'Internal Meeting ID') do |v|
    meeting_id = v
  end
end.parse!
raise 'Meeting ID was not provided' unless meeting_id

props = Psych.load_file(File.join(__dir__, '../bigbluebutton.yml'))
published_dir = props['published_dir'] || raise('Unable to determine published_dir from bigbluebutton.yml')
recording_dir = props['recording_dir']
raw_presentation_src = props['raw_presentation_src']

FileUtils.rm_rf("#{raw_presentation_src}/#{meeting_id}")
FileUtils.cp("#{raw_presentation_src}/recording/raw/#{meeting_id}/events.xml", "#{published_dir}/presentation/#{meeting_id}/events.xml")
