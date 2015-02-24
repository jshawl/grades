require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'lib/pull_request'

post '/' do
  res = JSON.parse( request.body.read )
  if res['action'] == 'opened'
    @pr = PullRequest.new( res['number'] )
    if @pr.errors? != []
      message = @pr.errors?.join("\n\n")
    else
      message = "Pull request passes automatic validation."
    end

    url = "https://api.github.com/repos/#{ENV['org_repo']}/issues/#{@pr.id.to_s}/comments?access_token=#{ENV['github_access_token']}"
    res = HTTParty.post(url, {body: message.to_json})
  end
end
