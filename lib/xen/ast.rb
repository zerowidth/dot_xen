module XenConfigFile
  module AST
    include Treehouse::NodeDefinition

    node :config_file, :declarations => :elements do
      def comments
        declarations.select { |v| v.kind_of? Comment }
      end

      def delete(name)
        if node = self[name]
          declarations.delete_at(declarations.index(node))
        end
      end

      def [](name)
        declarations.detect do |declaration|
          declaration.respond_to?(:name) && declaration.name.value == name
        end
      end

      def []=(name, value)
        new_name = StringLiteral.new(:value => name)

        index = self[name] ? declarations.index(self[name]) : declarations.size

        new_value = node_for(value, name=="disk")
        new_node = if value.kind_of?(Array)
          if name == "disk"
            DiskArrayAssignment.new(:name => new_name, :disks => new_value)
          else
            ArrayAssignment.new(:name => new_name, :values => new_value)
          end
        else
          Assignment.new(:name => new_name, :value => new_value)
        end

        declarations[index] = new_node
      end

      protected

      def node_for(value, is_disk=false)
        case value
        when String
          if is_disk
            Disk.new(SingleQuotedString.new(:value => value))
          else
            SingleQuotedString.new :value => value
          end
        when Integer
          Number.new :value => value
        when Array
          value.map { |v| node_for(v, is_disk) }
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