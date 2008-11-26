#!/usr/bin/env ruby
#
# Mechanical Uncle Bob
#
# Iterates through your source repository and figures out if you're writing
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
  
  def run
    stats = commits.inject({}) do |stats, (commit_sha, commit_stats)|
      stats[commit_sha] = commit_stats.to_diffstat
      # stats[commit_sha] = commit_stats.to_hash
      stats
    end
    
    pp stats
  end
  
end

if __FILE__ == $PROGRAM_NAME
  MechanicalUncleBob.run(ARGV)
end
