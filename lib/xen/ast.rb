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

        new_value = node_for(value, name=="disk")
        new_node = if value.kind_of?(Array) && name == "disk"
          DiskArrayAssignment.new(:name => name, :disks => new_value)
        else
          Assignment.new(:name => name, :value => new_value)
        end

        declarations[index] = new_node
      end

      protected

      def node_for(value, is_disk=false)
        case value
        when String
          if is_disk
            Disk.new(value)
          else
            value
          end
        when Integer
          value
        when Array
          value.map { |v| node_for(v, is_disk) }
        else
          raise "don't know what to do with #{value.class}"
        end
      end

    end

    # FIXME (nathan) :value => :value should automatically assume text_value unless it responds to #build
    node :comment, :value => lambda { |node| node.value.text_value }
    node :assignment, :name, :value
    node :disk_array_assignment, :name, :disks

    node :disk do
      attr_reader :volume, :device, :mode

      # override the default initialize with a custom initialize that takes a string literal instead
      def initialize(string)
        @volume, @device, @mode = string.split(",")
      end

    end

  end
end