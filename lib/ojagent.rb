require 'ojagent/version'
require 'ojagent/ojagent.rb'

libdir = File.join(File.expand_path(File.dirname(__FILE__)), 'ojagent')
Dir.entries(libdir).each do |filename|
  require File.join(libdir, filename) if filename.end_with? '_agent.rb'
end

module OJAgent
  # Return all avialbe agents.
  def self.all
    ObjectSpace.each_object(Class).select{|agent| agent < OJAgent}
  end

  # All avialbe agents at initial time.
  StandardAgents = all
end
