require 'httparty'
require 'pry'

class PullRequest
  attr_accessor :title, :description, :errors, :commits, :id
  def initialize id = 0
    @id = id
    @title = ''
    @description = ''
    @commits = []
    if( id != 0 )
      res = HTTParty.get("https://api.github.com/repos/jshawl/grades/pulls/#{id}?access_token=" + ENV['access_token'])
      @title = res['title']
      @author = res['user']['login']
      @description = res['body']
      commits = HTTParty.get("https://api.github.com/repos/jshawl/grades/pulls/#{id}/commits?access_token=" + ENV['access_token'])      
      commits.each do |commit|
	url = commit['url'] + "?access_token=" + ENV['access_token']
	files = HTTParty.get( url )['files'].map{ |f| f['filename'] }
	@commits.push({ sha: commit['sha'], files: files })
      end
    end
  end
  def valid_changes?
    @commits.each do |c|
      c[:files].each do |f|
	if f !~ /students\/#{@author}/
	  return false
	end
      end
    end
    true
  end
  def valid_title?
    true if @title.match(/w[0-9]{2}d[0-9]{2}/)
  end
  def comfort?
    true if @description.match(/comfort: [0-5]/)
  end
  def completeness?
    true if @description.match(/completeness: ?[0-5]/)
  end
  def errors?
    @errors = []
    unless valid_title?
      @errors << "Title must be in w##d## format."
    end
    unless comfort?
      @errors << "Description must contain comfort value."
    end
    unless completeness?
      @errors << "Description must contain completeness value."
    end
    unless valid_changes?
      @errors << "You have committed changes outside of your student folder."
    end
    @errors
  end
end
