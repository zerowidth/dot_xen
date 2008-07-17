module XenConfigFile
  include Treehouse::VisitorDefinition
  visitor :pretty_print_visitor do
    visits AST::ConfigFile do |config_file|
      str = ""
      config_file.declarations.each do |declaration|
        str << visit(declaration)
      end
      str
    end

    visits AST::Comment do |comment|
      "##{comment.value}\n"
    end

    visits AST::Assignment do |assignment|
      "#{assignment.name} = #{visit(assignment.value, assignment.name.length)}\n"
    end

    visits Array do |values, lhs_length|
      lhs_length += 5 # include the " = " and indent 2 more
      if values.size == 0
        ""
      elsif values.size == 1
        "[ #{visit(values.first)} ]"
      else
        str = "[\n"
        buf = ""
        values.each do |value|
          buf << " "*lhs_length << visit(value) << ",\n"
        end
        buf << " "*(lhs_length-2) << "]"
        str << buf << ""
      end
    end

    visits AST::Disk do |disk|
      "'#{disk.volume},#{disk.device},#{disk.mode}'"
    end

    visits String do |str, _|
      "'" + str + "'" # TODO add in ' quoting if necessary, or switch to "'s
    end

    visits Fixnum do |int, _|
      int.to_s
    end

  end
end
