require 'quotes/config'
require 'quotes/processor'

module Quotes
  extend self

  def scan(opts)
    config = Config.new opts
    config.files.each do |file|
      Processor.process(file, config.ruby_parser, config.force?)
    end
  end
end
