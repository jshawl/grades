class PullRequest
  attr_accessor :title, :description, :errors
  def initialize
    @title = 'w03d02'
    @description = ''
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
    @errors
  end
end