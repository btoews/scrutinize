require 'scrutinize/trigger'

module Scrutinize
  class Config
    KNOWN_VERSIONS = %w(ruby18 ruby19 ruby20 ruby21 ruby22, ruby23, ruby24)

    def initialize(opts = {})
      @options = opts
    end

    def [](key)
      @options[key]
    end

    def files
      Dir.glob(File.join(@options['dir'], "**/*.rb"))
    end

    # Public: A Trigger object based on the configured options.
    #
    # Returns a Trigger.
    def trigger
      @trigger ||= begin
        trigger = Scrutinize::Trigger.new

        # Trigger configured at top level
        keys = %w(methods method targets target)
        unless (@options.keys & keys).empty?
          trigger.add @options.select { |k,v| keys.include?(k) }
        end

        # Trigger configured under trigger key
        trigger.add @options['trigger'] if @options['trigger'].is_a?(Hash)

        # Triggers configured under triggers key
        if @options['triggers'].is_a? Array
          @options['triggers'].each { |t| trigger.add t }
        end

        trigger
      end
    end

    # Public: The normalized Ruby version, inferred from RUBY_VERSION and the
    # configured version.
    #
    # Returns a String.
    def ruby_version
      @ruby_version ||= begin
        version = @options['ruby_version'] || RUBY_VERSION
        normalize_version version
      end
    end

    # Public: Set a new Ruby version.
    #
    # value - A String Ruby version.
    #
    # Returns the normalized value provided.
    def ruby_version=(value)
      normalize_version(value).tap do |version|
        @ruby_version = @options['ruby_version'] = version
        @ruby_parser = parser_for_version version
      end
    end

    # Public: A Parser instance for the configured Ruby version.
    #
    # Returns a Parser.
    def ruby_parser
      @ruby_parser ||= parser_for_version ruby_version
    end

    private

    # Normalize a Ruby version.
    #
    # version - A Ruby version String.
    #
    # Returns a String.
    def normalize_version(version)
      return version if KNOWN_VERSIONS.include?(version)

      case version
      when /^1\.8\./
        'ruby18'
      when /^1\.9\./
        'ruby19'
      when /^2\.0\./
        'ruby20'
      when /^2\.1\./
        'ruby21'
      when /^2\.2\./
        'ruby22'
      when /^2\.3\./
        'ruby23'
      when /^2\.4\./
        'ruby24'
      else
        raise NotImplementedError, "unsupported Ruby version '#{version}'"
      end
    end

    # Get the correct Parser class for a given Ruby version.
    #
    # version - A Ruby version String.
    #
    # Returns a Parser class.
    def parser_for_version(version)
      require "parser/#{version}"
      Parser.const_get version.capitalize
    end
  end
end
