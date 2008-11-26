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

require 'grit'

# class Grit::CommitStats
#   def to_diffstat
#     files.map do |metadata|
#       DiffStat.new(*metadata)
#     end
#   end
# end
# 
# class DiffStat
#   attr_reader :filename, :additions, :deletions
#   
#   def initialize(filename, additions, deletions, total=nil)
#     @filename, @additions, @deletions = filename, additions, deletions
#   end
#   
#   def inspect
#     "#{filename}: +#{additions} -#{deletions}"
#   end
# end

class MechanicalUncleBob
  
  def self.run(args)
    new(args[0], args[1]).run
  end
  
  attr_reader :path, :limit
  
  def initialize(path, limit)
    @path, @limit = path, limit
  end
  
  def repo
    puts "Loading Git repo from #{path}"
    @repo ||= Grit::Repo.new(path)
  end
  
  def commits
    repo.commit_stats('master', limit)
  end
  
  def run
    stats = commits.inject({}) do |stats, (commit_sha, commit_stats)|
      puts commit_sha
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
