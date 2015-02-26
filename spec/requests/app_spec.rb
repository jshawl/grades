require 'spec_helper'

RSpec.describe "HW App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:pr_id) { 55555 }
  let(:valid_pr_data) { {"title" => "w01d01", "body" => "comfort: 4 \ncompleteness: 3", "user" => {"login" => "pr_test"} }}

  context "PR has no title" do
    before(:each) do
      data_without_title = valid_pr_data.merge("title" => '')
      # first request from pull_request.rb
      stub_request(:any, "https://api.github.com/repos/#{ENV['org_repo']}/pulls/#{pr_id}?access_token=#{ENV['github_access_token']}").
        to_return( body: data_without_title.to_json )
      stub_request(:any, /api.github.com.*commits/).to_return( body: {}.to_json )
      stub_request(:any, /api.github.com.*issues.*comments/)
    end

    it "should post a comment stating 'invalid title' to the PR" do
      # simulates github webhook
      post "/", { "action" => "opened", "number" => pr_id }.to_json

      # this is what the app should do, make an API request to create a comment
      expect(WebMock).to have_requested(:post, "https://api.github.com/repos/#{ENV['org_repo']}/issues/#{pr_id}/comments?access_token=#{ENV['github_access_token']}").
        with(:body => /Title must be/i)
    end
  end
end
