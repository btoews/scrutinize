module Quotes
  class Processor
    # Process a file with a Trigger.
    #
    # Returns nothing.
    def self.process(file, parser, force)
      new(file, parser, force).process
    end

    # Initialize a Processor instance.
    #
    # file - the file to be processed.
    def initialize(file, parser, force)
      @file   = file
      @parser = parser
      @force  = force
    end

    # Process the AST of the file.
    #
    # Returns nothing.
    def process
      process_node ast
      write_src if @replaced
    rescue Parser::SyntaxError
    end

    # Recurse into an Parser::AST::Node, calling appropriate process functions
    # for it and its children nodes.
    #
    # node - a Parser::AST::Node object.
    #
    # Returns nothing.
    def process_node(node)
      if node?(node)
        if node.type == :str
          process_str(node)
        else
          node.children.each { |c| process_node c }
        end
      end
    end

    # Process a :send Parser::AST::Node. Call any registered handler for the
    # target/method being invoked.
    #
    # node - a Parser::AST::Node object.
    #
    # Returns nothing.
    def process_str(node)
      str_value = node.children.first
      src_value = get_src(node)

      # Only interested in single quoted strings.
      return unless src_value =~ /\A'.*'\z/

      # Make sure nothing needs escaping.
      return unless src_value[1...-1] == str_value.inspect[1...-1]

      puts "#{@file}:#{node.loc.line} #{src_value}"

      replace(node, str_value.inspect) if @force
    end

    def replace(node, replacement)
      range = node.loc.expression

      # Line numbers start at 1
      begin_line = range.begin.line - 1
      end_line   = range.end.line - 1

      raise "Can't replace multiple lines" unless begin_line == end_line

      # Column numbers start at 0
      begin_column = range.begin.column
      end_column   = range.end.column

      src_lines[begin_line][begin_column...end_column] = replacement
      @replaced = true
    end

    # Is an object a Parser::AST::Node.
    #
    # node - the object to test.
    #
    # Returns true/false.
    def node?(node)
      node.is_a? Parser::AST::Node
    end

    # Gets the source code of a given node.
    #
    # node - a Parser::AST::Node object.
    #
    # Returns a String.
    def get_src(node)
      range = node.loc.expression

      # Line numbers start at 1
      begin_line   = range.begin.line - 1
      end_line     = range.end.line - 1
      middle_lines = begin_line + 1 ... end_line - 1

      # Column numbers start at 0
      begin_column = range.begin.column
      end_column   = range.end.column

      # Beginning/ending on same line
      if begin_line == end_line
        return src_lines[begin_line][begin_column...end_column]
      end

      lines = []
      lines << src_lines[begin_line][begin_column..-1]
      lines += src_lines[middle_lines]
      lines << src_lines[end_line][0...end_line]
      lines.join "\n"
    end

    # The AST of the source code.
    #
    # Returns a Parser::AST::Node object.
    def ast
      @ast ||= @parser.parse src
    end

    def write_src
      File.open(@file, "w") do |f|
        f.write src_lines.join
      end
    end

    # The source code, broken up into lines.
    #
    # Returns an Array of Strings.
    def src_lines
      @src_lines ||= src.lines.to_a
    end

    # The source code.
    #
    # Returns a String.
    def src
      @src ||= File.read @file
    end
  end
end
