require_relative 'spec_helper'
require_relative '../lib/pull_request'

describe PullRequest do
  it "should have a title" do
    @pr = PullRequest.new
    expect(@pr.title).to_not eq(nil)
  end
  it "should be of wnndnn format" do
    @pr = PullRequest.new(6)
    expect(@pr.valid_title?).to eq(true)
    @pr = PullRequest.new(3)
    expect(@pr.valid_title?).to eq(nil)
  end
  it "have errors for incorrect names" do
    @pr = PullRequest.new
    @pr.title = "W02 d03"
    expect(@pr.errors?).to_not eq(nil)
  end
  it "have errors for incorrect names" do
    @pr = PullRequest.new( 6 )
    expect(@pr.errors?).to_not eq(nil)
  end
  it "should have a comfort value" do
    @pr = PullRequest.new( 6 )
    expect(@pr.comfort?).to eq(true)
  end
  it "should have a completeness value" do
    @pr = PullRequest.new( 6 )
    expect(@pr.completeness?).to eq(true)
    @pr.description = "comfort: 3\n :3"
    expect(@pr.completeness?).to eq(nil)
  end
  it "should have many commits" do
    @pr = PullRequest.new( 2 )
    expect(@pr.commits.empty?).to be(false)
  end
  it "should not have changes to assignments folder" do
    @pr = PullRequest.new( 2 )
    expect(@pr.valid_changes?).to eq(false)
    @pr = PullRequest.new( 4 )
    expect(@pr.valid_changes?).to eq(true)
  end
  it "should only have changes to appropriate student folder" do
    @pr = PullRequest.new( 4 )
    expect(@pr.valid_changes?).to eq(true)
    @pr = PullRequest.new( 5 )
    expect(@pr.valid_changes?).to eq(false)
  end
end