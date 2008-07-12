module XenConfigFile
  module AST
    include Treehouse::NodeDefinition

    node :config_file, :declarations => :elements do
      def comments
        declarations.select { |v| v.kind_of? Comment }
      end

      def [](name)
        declarations.detect do |declaration|
          ( declaration.kind_of?(Assignment) ||
            declaration.kind_of?(ArrayAssignment) ||
            declaration.kind_of?(DiskArrayAssignment)
          ) && declaration.name.value == name
        end
      end

      def []=(name, value)
        new_value = node_for(value)

        if self[name]
          self[name].value = new_value
        else
          new_name = StringLiteral.new(:value => name)
          if value.kind_of?(Array)
            declarations << ArrayAssignment.new(:name => new_name, :values => new_value)
          else
            declarations << Assignment.new(:name => new_name, :value => new_value)
          end
        end
      end

      protected

      def node_for(value)
        case value
        when String
          SingleQuotedString.new :value => value
        when Integer
          Number.new :value => value
        when Array
          value.map { |v| node_for(v) }
        else
          raise "don't know what to do with #{value.class}"
        end
      end

    end

    node :comment, :value => lambda { |node| node.value.text_value }
    node :assignment, :name, :value
    node :array_assignment, :name, :values
    node :disk_array_assignment, :name, :disks

    node :disk do
      attr_reader :volume, :device, :mode

      # override the default initialize with a custom initialize that takes a string literal instead
      def initialize(string_node)
        @volume, @device, @mode = string_node.value.split(",")
      end

    end

    node :string_literal, :value => :text_value
    node :single_quoted_string, :value => lambda { |node| node.elements[1].text_value }
    node :double_quoted_string, :value => lambda { |node| node.elements[1].text_value }
    node :number, :value => lambda { |node| node.text_value.to_i }

  end
end