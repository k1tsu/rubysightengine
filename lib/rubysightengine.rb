require "rubysightengine/version"
require_relative "rubysightengine/client"

module SightEngine
  class Error < StandardError; end
  class << self

    def new(a, b, c=nil)

      return SightEngineE.new(a, b, c)

    end 

  end 

end
