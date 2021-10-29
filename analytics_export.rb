#!/usr/bin/ruby
 
require 'rubygems' 
require 'fileutils' 
require "trollop" 

opts = Trollop::options do
  opt :meeting_id, "Meeting id to archive", :type => String
  opt :format, "Playback server", :type => String end
meeting_id = opts[:meeting_id]

system("cp $(ls -d /var/bigbluebutton/learning-dashboard/#{meeting_id}/*/|head -n 1)learning_dashboard_data.json /var/bigbluebutton/published/presentation/#{meeting_id}/learning_dashboard_data.json")
system("rm -rf /var/bigbluebutton/learning-dashboard/#{meeting_id}/")
