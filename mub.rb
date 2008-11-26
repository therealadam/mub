#!/usr/bin/env ruby
#
# MUB is the Mechanical Uncle Bob
#
# It iterates through your source repository and figures out if you're writing
# enough tests. If you aren't, it yells at you.
#
# DISCLAIMER: I have not met Uncle Bob. He may or may not yell at you and he 
#             may or may not use bipedal motion.
#

require 'rubygems'
require 'pp'

$LOAD_PATH << File.join(Dir.getwd, 'vendor', 'grit', 'lib')
require 'grit'

class MechanicalUncleBob
  
  def self.run(args)
    new(args[0], args[1]).run
  end
  
  attr_reader :path, :limit
  
  def initialize(path, limit)
    @path, @limit = path, limit
  end
  
  def repo
    @repo ||= Grit::Repo.new(path)
  end
  
  def commits
    repo.commit_stats('master', limit)
  end
  
  def totals_for(diffstats)
    stats = {:app => [], :tests => []}
    diffstats.each do |diffstat|
      next if ignore?(diffstat.filename)
      stats[category_for(diffstat.filename)] << diffstat.net
    end
    
    {:app => stats[:app].inject(0) { |sum, value| sum + value },
     :tests => stats[:app].inject(0) { |sum, value| sum + value }}
  end
  
  def category_for(path)
    key = case path
    when /^app/ then :app
    when %r{^public/javascripts} then :app
    when /^features/ then :tests
    when /^test/ then :tests
    else raise "Unknown category for #{path}"
    end
  end
  
  def ignore?(path)
    [/^doc/, 
     %r{^public/images}, 
     %r{^public/stylesheets}, 
     /^config/].any? { |pattern| pattern.match(path) }
  end
  
  def run
    stats = commits.inject({}) do |stats, (commit_sha, commit_stats)|
      stats[commit_sha] = commit_stats.to_diffstat
      stats
    end
    
    totals = stats.map { |(commit, stat)| totals_for(stat) }
    pp totals
  end
  
end

if __FILE__ == $PROGRAM_NAME
  MechanicalUncleBob.run(ARGV)
end
