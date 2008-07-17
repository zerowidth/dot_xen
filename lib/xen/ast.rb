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
          declaration.respond_to?(:name) && declaration.name == name
        end
      end

      def []=(name, value)
        index = self[name] ? declarations.index(self[name]) : declarations.size

        if value.kind_of?(Array) && name == "disk"
          value = value.map { |v| v.kind_of?(Disk) ? v : Disk.new(v) }
        end
        new_node = Assignment.new(:name => name, :value => value)

        declarations[index] = new_node
      end

    end

    node :comment, :value => lambda { |node| node.value.text_value }
    node :assignment, :name, :value

    node :disk do
      attr_reader :volume, :device, :mode

      # override the default initialize with a custom initialize that takes a string literal instead
      def initialize(string)
        @volume, @device, @mode = string.split(",")
      end

    end

  end
end
