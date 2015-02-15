class PullRequest
  attr_accessor :title
  def initialize
    @title = 'w03d02'
  end
  def valid_title?
    true if @title.match(/w[0-9]{2}d[0-9]{2}/)
  end
  def errors?
    @errors = []
    unless valid_title?
      @errors << "Title must be in w##d## format."
    end
  end
end