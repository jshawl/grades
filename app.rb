require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/pull_request'

post '/' do
  @pr = PullRequest.new( params["number"] )
  if @pr.errors?
    data = {
      state:'closed'
    }
    res = HTTParty.patch('https://api.github.com/repos/jshawl/grades/pulls/' + @pr.id.to_s + '?access_token=' + ENV['access_token'], {
      body: data.to_json
    })
    comment = {
      body: @pr.errors?.join("\n\n")
    }
    res = HTTParty.post('https://api.github.com/repos/jshawl/grades/issues/' + @pr.id.to_s + '/comments?access_token=' + ENV['access_token'], {
      body: comment.to_json
    })
  end
end