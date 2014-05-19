module Scrutinize
  class Processor
    # Process a file with a Trigger.
    #
    # Returns nothing.
    def self.process(file, trigger, parser)
      new(file, trigger, parser).process
    end

    # Initialize a Processor instance.
    #
    # file - the file to be processed.
    def initialize(file, trigger, parser)
      @file    = file
      @trigger = trigger
      @parser  = parser
    end

    # Process the AST of the file.
    #
    # Returns nothing.
    def process
      process_node ast
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
        process_send(node) if node.type == :send
        node.children.each { |c| process_node c }
      end
    end

    # Process a :send Parser::AST::Node. Call any registered handler for the
    # target/method being invoked.
    #
    # node - a Parser::AST::Node object.
    #
    # Returns nothing.
    def process_send(node)
      target = get_src node.children[0] if node.children[0]
      target = target.slice(2..-1) if node.children[0] && target.start_with?('::')
      method = node.children[1]

      if @trigger.match? target, method
        puts "#{@file}:#{node.loc.line} #{target}#{'.' if target}#{method}"
      end
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

    # The source code, broken up into lines.
    #
    # Returns an Array of Strings.
    def src_lines
      @src_lines = src.lines.to_a
    end

    # The source code.
    #
    # Returns a String.
    def src
      @src ||= File.read @file
    end
  end
end
