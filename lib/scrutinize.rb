require 'scrutinize/config'
require 'scrutinize/processor'

module Scrutinize
  extend self

  def scan(opts)
    config = Config.new opts
    config.files.each do |file|
      Processor.process(file, config.trigger, config.ruby_parser)
    end
  end
end
