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
      "#{assignment.name} = #{visit(assignment.value)}\n"
    end
    visits AST::ArrayAssignment do |assignment|
      if assignment.values.size == 0 || assignment.values.nil?
        ""
      elsif assignment.values.size > 1
        str = "#{assignment.name} = [\n"
        buf = ""
        assignment.values.each do |value|
          buf << " "*str.size << visit(value) << ",\n"
        end
        buf << " "*(str.size-2) << "]"
        str << buf << "\n"
      else
        "#{assignment.name} = [ #{visit(assignment.values.first)} ]\n"
      end
    end
    visits AST::DiskArrayAssignment do |assignment|
      if assignment.disks.size == 0 || assignment.disks.nil?
        ""
      elsif assignment.disks.size > 1
        str = "#{assignment.name} = [\n"
        buf = ""
        assignment.disks.each do |value|
          buf << " "*str.size << visit(value) << ",\n"
        end
        buf << " "*(str.size-2) << "]"
        str << buf << "\n"
      else
        "#{assignment.lhs} = [ #{visit(assignment.disks.first)} ]\n"
      end
    end
    visits AST::Disk do |disk|
      "'#{disk.volume},#{disk.device},#{disk.mode}'"
    end

    visits String do |str|
      "'" + str + "'" # TODO add in ' quoting if necessary, or switch to "'s
    end
    visits Fixnum do |int|
      int.to_s
    end

  end
end