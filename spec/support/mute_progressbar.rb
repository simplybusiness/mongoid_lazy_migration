require 'ruby-progressbar'

class ProgressBar
  class DoNothing
    def method_missing(m, *args, &block)
      self
    end
  end

  def self.create(options = {})
    DoNothing.new
  end
end
