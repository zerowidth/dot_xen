module XenConfigFile
  module Grammar
    include Treetop::Runtime

    def root
      @root || :config_file
    end

    def _nt_config_file
      start_index = index
      if node_cache[:config_file].has_key?(index)
        cached = node_cache[:config_file][index]
        @index = cached.interval.end if cached
        return cached
      end

      s0, i0 = [], index
      loop do
        i1 = index
        r2 = _nt_comment
        if r2
          r1 = r2
        else
          r3 = _nt_blank_line
          if r3
            r1 = r3
          else
            r4 = _nt_assignment
            if r4
              r1 = r4
            else
              self.index = i1
              r1 = nil
            end
          end
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      r0 = AST.create_node(:config_file).new(input, i0...index, s0)

      node_cache[:config_file][start_index] = r0

      return r0
    end

    module Assignment0
      def name
        elements[1]
      end

      def value
        elements[5]
      end

    end

    module Assignment1
      def name
        elements[2]
      end

      def disks
        elements[8]
      end

    end

    module Assignment2
      def name
        elements[1]
      end

      def values
        elements[7]
      end

    end

    def _nt_assignment
      start_index = index
      if node_cache[:assignment].has_key?(index)
        cached = node_cache[:assignment][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      s2, i2 = [], index
      loop do
        r3 = _nt_space_no_newline
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s1 << r2
      if r2
        r4 = _nt_variable
        s1 << r4
        if r4
          s5, i5 = [], index
          loop do
            r6 = _nt_space_no_newline
            if r6
              s5 << r6
            else
              break
            end
          end
          r5 = SyntaxNode.new(input, i5...index, s5)
          s1 << r5
          if r5
            if input.index('=', index) == index
              r7 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('=')
              r7 = nil
            end
            s1 << r7
            if r7
              s8, i8 = [], index
              loop do
                r9 = _nt_space_no_newline
                if r9
                  s8 << r9
                else
                  break
                end
              end
              r8 = SyntaxNode.new(input, i8...index, s8)
              s1 << r8
              if r8
                r10 = _nt_variable
                s1 << r10
                if r10
                  s11, i11 = [], index
                  loop do
                    r12 = _nt_space
                    if r12
                      s11 << r12
                    else
                      break
                    end
                  end
                  r11 = SyntaxNode.new(input, i11...index, s11)
                  s1 << r11
                  if r11
                    s13, i13 = [], index
                    loop do
                      r14 = _nt_comment
                      if r14
                        s13 << r14
                      else
                        break
                      end
                    end
                    r13 = SyntaxNode.new(input, i13...index, s13)
                    s1 << r13
                  end
                end
              end
            end
          end
        end
      end
      if s1.last
        r1 = (AST.create_node(:assignment)).new(input, i1...index, s1)
        r1.extend(Assignment0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        i15, s15 = index, []
        s16, i16 = [], index
        loop do
          r17 = _nt_space_no_newline
          if r17
            s16 << r17
          else
            break
          end
        end
        r16 = SyntaxNode.new(input, i16...index, s16)
        s15 << r16
        if r16
          i18 = index
          if input.index("disk", index) == index
            r19 = (SyntaxNode).new(input, index...(index + 4))
            @index += 4
          else
            terminal_parse_failure("disk")
            r19 = nil
          end
          if r19
            self.index = i18
            r18 = SyntaxNode.new(input, index...index)
          else
            r18 = nil
          end
          s15 << r18
          if r18
            r20 = _nt_variable
            s15 << r20
            if r20
              s21, i21 = [], index
              loop do
                r22 = _nt_space_no_newline
                if r22
                  s21 << r22
                else
                  break
                end
              end
              r21 = SyntaxNode.new(input, i21...index, s21)
              s15 << r21
              if r21
                if input.index('=', index) == index
                  r23 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('=')
                  r23 = nil
                end
                s15 << r23
                if r23
                  s24, i24 = [], index
                  loop do
                    r25 = _nt_space_no_newline
                    if r25
                      s24 << r25
                    else
                      break
                    end
                  end
                  r24 = SyntaxNode.new(input, i24...index, s24)
                  s15 << r24
                  if r24
                    if input.index('[', index) == index
                      r26 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('[')
                      r26 = nil
                    end
                    s15 << r26
                    if r26
                      s27, i27 = [], index
                      loop do
                        r28 = _nt_space
                        if r28
                          s27 << r28
                        else
                          break
                        end
                      end
                      r27 = SyntaxNode.new(input, i27...index, s27)
                      s15 << r27
                      if r27
                        r29 = _nt_disk_array_list
                        s15 << r29
                        if r29
                          s30, i30 = [], index
                          loop do
                            r31 = _nt_space
                            if r31
                              s30 << r31
                            else
                              break
                            end
                          end
                          r30 = SyntaxNode.new(input, i30...index, s30)
                          s15 << r30
                          if r30
                            if input.index(']', index) == index
                              r32 = (SyntaxNode).new(input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure(']')
                              r32 = nil
                            end
                            s15 << r32
                            if r32
                              s33, i33 = [], index
                              loop do
                                r34 = _nt_space
                                if r34
                                  s33 << r34
                                else
                                  break
                                end
                              end
                              r33 = SyntaxNode.new(input, i33...index, s33)
                              s15 << r33
                              if r33
                                s35, i35 = [], index
                                loop do
                                  r36 = _nt_comment
                                  if r36
                                    s35 << r36
                                  else
                                    break
                                  end
                                end
                                r35 = SyntaxNode.new(input, i35...index, s35)
                                s15 << r35
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        if s15.last
          r15 = (AST.create_node(:disk_array_assignment)).new(input, i15...index, s15)
          r15.extend(Assignment1)
        else
          self.index = i15
          r15 = nil
        end
        if r15
          r0 = r15
        else
          i37, s37 = index, []
          s38, i38 = [], index
          loop do
            r39 = _nt_space_no_newline
            if r39
              s38 << r39
            else
              break
            end
          end
          r38 = SyntaxNode.new(input, i38...index, s38)
          s37 << r38
          if r38
            r40 = _nt_variable
            s37 << r40
            if r40
              s41, i41 = [], index
              loop do
                r42 = _nt_space_no_newline
                if r42
                  s41 << r42
                else
                  break
                end
              end
              r41 = SyntaxNode.new(input, i41...index, s41)
              s37 << r41
              if r41
                if input.index('=', index) == index
                  r43 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('=')
                  r43 = nil
                end
                s37 << r43
                if r43
                  s44, i44 = [], index
                  loop do
                    r45 = _nt_space_no_newline
                    if r45
                      s44 << r45
                    else
                      break
                    end
                  end
                  r44 = SyntaxNode.new(input, i44...index, s44)
                  s37 << r44
                  if r44
                    if input.index('[', index) == index
                      r46 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('[')
                      r46 = nil
                    end
                    s37 << r46
                    if r46
                      s47, i47 = [], index
                      loop do
                        r48 = _nt_space
                        if r48
                          s47 << r48
                        else
                          break
                        end
                      end
                      r47 = SyntaxNode.new(input, i47...index, s47)
                      s37 << r47
                      if r47
                        r49 = _nt_array_list
                        s37 << r49
                        if r49
                          s50, i50 = [], index
                          loop do
                            r51 = _nt_space
                            if r51
                              s50 << r51
                            else
                              break
                            end
                          end
                          r50 = SyntaxNode.new(input, i50...index, s50)
                          s37 << r50
                          if r50
                            if input.index(']', index) == index
                              r52 = (SyntaxNode).new(input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure(']')
                              r52 = nil
                            end
                            s37 << r52
                            if r52
                              s53, i53 = [], index
                              loop do
                                r54 = _nt_space
                                if r54
                                  s53 << r54
                                else
                                  break
                                end
                              end
                              r53 = SyntaxNode.new(input, i53...index, s53)
                              s37 << r53
                              if r53
                                s55, i55 = [], index
                                loop do
                                  r56 = _nt_comment
                                  if r56
                                    s55 << r56
                                  else
                                    break
                                  end
                                end
                                r55 = SyntaxNode.new(input, i55...index, s55)
                                s37 << r55
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          if s37.last
            r37 = (AST.create_node(:array_assignment)).new(input, i37...index, s37)
            r37.extend(Assignment2)
          else
            self.index = i37
            r37 = nil
          end
          if r37
            r0 = r37
          else
            self.index = i0
            r0 = nil
          end
        end
      end

      node_cache[:assignment][start_index] = r0

      return r0
    end

    module ArrayList0
      def list
        elements[1]
      end

    end

    module ArrayList1
      def values
        elements[1]
      end

      def remains
        elements[4]
      end
    end

    module ArrayList2
      # FIXME (nathan) automate this (:recursive => true flag?)
      def build
        ([values.build] + remains.elements.map { |e| e.list.build }).flatten
      end
    end

    def _nt_array_list
      start_index = index
      if node_cache[:array_list].has_key?(index)
        cached = node_cache[:array_list][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      s1, i1 = [], index
      loop do
        r2 = _nt_space
        if r2
          s1 << r2
        else
          break
        end
      end
      r1 = SyntaxNode.new(input, i1...index, s1)
      s0 << r1
      if r1
        i3 = index
        r4 = _nt_variable
        if r4
          r3 = r4
        else
          r5 = _nt_comment
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        s0 << r3
        if r3
          if input.index(',', index) == index
            r7 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(',')
            r7 = nil
          end
          if r7
            r6 = r7
          else
            r6 = SyntaxNode.new(input, index...index)
          end
          s0 << r6
          if r6
            s8, i8 = [], index
            loop do
              r9 = _nt_space
              if r9
                s8 << r9
              else
                break
              end
            end
            r8 = SyntaxNode.new(input, i8...index, s8)
            s0 << r8
            if r8
              s10, i10 = [], index
              loop do
                i11, s11 = index, []
                s12, i12 = [], index
                loop do
                  r13 = _nt_space
                  if r13
                    s12 << r13
                  else
                    break
                  end
                end
                r12 = SyntaxNode.new(input, i12...index, s12)
                s11 << r12
                if r12
                  r14 = _nt_array_list
                  s11 << r14
                  if r14
                    s15, i15 = [], index
                    loop do
                      r16 = _nt_space
                      if r16
                        s15 << r16
                      else
                        break
                      end
                    end
                    r15 = SyntaxNode.new(input, i15...index, s15)
                    s11 << r15
                    if r15
                      if input.index(',', index) == index
                        r18 = (SyntaxNode).new(input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(',')
                        r18 = nil
                      end
                      if r18
                        r17 = r18
                      else
                        r17 = SyntaxNode.new(input, index...index)
                      end
                      s11 << r17
                    end
                  end
                end
                if s11.last
                  r11 = (SyntaxNode).new(input, i11...index, s11)
                  r11.extend(ArrayList0)
                else
                  self.index = i11
                  r11 = nil
                end
                if r11
                  s10 << r11
                else
                  break
                end
              end
              r10 = SyntaxNode.new(input, i10...index, s10)
              s0 << r10
            end
          end
        end
      end
      if s0.last
        r0 = (SyntaxNode).new(input, i0...index, s0)
        r0.extend(ArrayList1)
        r0.extend(ArrayList2)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:array_list][start_index] = r0

      return r0
    end

    module DiskArrayList0
      def list
        elements[1]
      end

    end

    module DiskArrayList1
      def values
        elements[1]
      end

      def remains
        elements[4]
      end
    end

    module DiskArrayList2
      # FIXME (nathan) automate this for arrays
      def build
        ([values.build] + remains.elements.map { |e| e.list.build }).flatten.map do |literal|
          literal.instance_of?(AST::Disk) ? literal : AST::Disk.new(literal)
        end
      end
    end

    def _nt_disk_array_list
      start_index = index
      if node_cache[:disk_array_list].has_key?(index)
        cached = node_cache[:disk_array_list][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      s1, i1 = [], index
      loop do
        r2 = _nt_space
        if r2
          s1 << r2
        else
          break
        end
      end
      r1 = SyntaxNode.new(input, i1...index, s1)
      s0 << r1
      if r1
        i3 = index
        r4 = _nt_variable
        if r4
          r3 = r4
        else
          r5 = _nt_comment
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        s0 << r3
        if r3
          if input.index(',', index) == index
            r7 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(',')
            r7 = nil
          end
          if r7
            r6 = r7
          else
            r6 = SyntaxNode.new(input, index...index)
          end
          s0 << r6
          if r6
            s8, i8 = [], index
            loop do
              r9 = _nt_space
              if r9
                s8 << r9
              else
                break
              end
            end
            r8 = SyntaxNode.new(input, i8...index, s8)
            s0 << r8
            if r8
              s10, i10 = [], index
              loop do
                i11, s11 = index, []
                s12, i12 = [], index
                loop do
                  r13 = _nt_space
                  if r13
                    s12 << r13
                  else
                    break
                  end
                end
                r12 = SyntaxNode.new(input, i12...index, s12)
                s11 << r12
                if r12
                  r14 = _nt_disk_array_list
                  s11 << r14
                  if r14
                    s15, i15 = [], index
                    loop do
                      r16 = _nt_space
                      if r16
                        s15 << r16
                      else
                        break
                      end
                    end
                    r15 = SyntaxNode.new(input, i15...index, s15)
                    s11 << r15
                    if r15
                      if input.index(',', index) == index
                        r18 = (SyntaxNode).new(input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(',')
                        r18 = nil
                      end
                      if r18
                        r17 = r18
                      else
                        r17 = SyntaxNode.new(input, index...index)
                      end
                      s11 << r17
                    end
                  end
                end
                if s11.last
                  r11 = (SyntaxNode).new(input, i11...index, s11)
                  r11.extend(DiskArrayList0)
                else
                  self.index = i11
                  r11 = nil
                end
                if r11
                  s10 << r11
                else
                  break
                end
              end
              r10 = SyntaxNode.new(input, i10...index, s10)
              s0 << r10
            end
          end
        end
      end
      if s0.last
        r0 = (SyntaxNode).new(input, i0...index, s0)
        r0.extend(DiskArrayList1)
        r0.extend(DiskArrayList2)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:disk_array_list][start_index] = r0

      return r0
    end

    module Variable0
      def value
        elements[1]
      end

    end

    module Variable1
      def build
        value.build
      end
    end

    module Variable2
      def value
        elements[1]
      end

    end

    module Variable3
      def build
        value.build
      end
    end

    def _nt_variable
      start_index = index
      if node_cache[:variable].has_key?(index)
        cached = node_cache[:variable][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      s2, i2 = [], index
      loop do
        r3 = _nt_space_no_newline
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s1 << r2
      if r2
        r4 = _nt_number
        s1 << r4
        if r4
          s5, i5 = [], index
          loop do
            r6 = _nt_space
            if r6
              s5 << r6
            else
              break
            end
          end
          r5 = SyntaxNode.new(input, i5...index, s5)
          s1 << r5
          if r5
            s7, i7 = [], index
            loop do
              r8 = _nt_comment
              if r8
                s7 << r8
              else
                break
              end
            end
            r7 = SyntaxNode.new(input, i7...index, s7)
            s1 << r7
          end
        end
      end
      if s1.last
        r1 = (SyntaxNode).new(input, i1...index, s1)
        r1.extend(Variable0)
        r1.extend(Variable1)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        i9, s9 = index, []
        s10, i10 = [], index
        loop do
          r11 = _nt_space_no_newline
          if r11
            s10 << r11
          else
            break
          end
        end
        r10 = SyntaxNode.new(input, i10...index, s10)
        s9 << r10
        if r10
          r12 = _nt_string
          s9 << r12
          if r12
            s13, i13 = [], index
            loop do
              r14 = _nt_space
              if r14
                s13 << r14
              else
                break
              end
            end
            r13 = SyntaxNode.new(input, i13...index, s13)
            s9 << r13
            if r13
              s15, i15 = [], index
              loop do
                r16 = _nt_comment
                if r16
                  s15 << r16
                else
                  break
                end
              end
              r15 = SyntaxNode.new(input, i15...index, s15)
              s9 << r15
            end
          end
        end
        if s9.last
          r9 = (SyntaxNode).new(input, i9...index, s9)
          r9.extend(Variable2)
          r9.extend(Variable3)
        else
          self.index = i9
          r9 = nil
        end
        if r9
          r0 = r9
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:variable][start_index] = r0

      return r0
    end

    module Number0
      def build
        text_value.to_i
      end
    end

    def _nt_number
      start_index = index
      if node_cache[:number].has_key?(index)
        cached = node_cache[:number][index]
        @index = cached.interval.end if cached
        return cached
      end

      s0, i0 = [], index
      loop do
        if input.index(Regexp.new('[0-9]'), index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r1 = nil
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      if s0.empty?
        self.index = i0
        r0 = nil
      else
        r0 = SyntaxNode.new(input, i0...index, s0)
        r0.extend(Number0)
      end

      node_cache[:number][start_index] = r0

      return r0
    end

    module String0
      def build
        text_value
      end
    end

    module String1
    end

    module String2
    end

    module String3
      def build
        elements[1].text_value
      end
    end

    module String4
    end

    module String5
    end

    module String6
      def build
        elements[1].text_value
      end
    end

    def _nt_string
      start_index = index
      if node_cache[:string].has_key?(index)
        cached = node_cache[:string][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      s1, i1 = [], index
      loop do
        if input.index(Regexp.new('[A-Za-z_-]'), index) == index
          r2 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r2 = nil
        end
        if r2
          s1 << r2
        else
          break
        end
      end
      if s1.empty?
        self.index = i1
        r1 = nil
      else
        r1 = SyntaxNode.new(input, i1...index, s1)
        r1.extend(String0)
      end
      if r1
        r0 = r1
      else
        i3, s3 = index, []
        if input.index('"', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r4 = nil
        end
        s3 << r4
        if r4
          s5, i5 = [], index
          loop do
            i6 = index
            i7, s7 = index, []
            i8 = index
            if input.index('"', index) == index
              r9 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('"')
              r9 = nil
            end
            if r9
              r8 = nil
            else
              self.index = i8
              r8 = SyntaxNode.new(input, index...index)
            end
            s7 << r8
            if r8
              if index < input_length
                r10 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r10 = nil
              end
              s7 << r10
            end
            if s7.last
              r7 = (SyntaxNode).new(input, i7...index, s7)
              r7.extend(String1)
            else
              self.index = i7
              r7 = nil
            end
            if r7
              r6 = r7
            else
              if input.index('\"', index) == index
                r11 = (SyntaxNode).new(input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure('\"')
                r11 = nil
              end
              if r11
                r6 = r11
              else
                self.index = i6
                r6 = nil
              end
            end
            if r6
              s5 << r6
            else
              break
            end
          end
          r5 = SyntaxNode.new(input, i5...index, s5)
          s3 << r5
          if r5
            if input.index('"', index) == index
              r12 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('"')
              r12 = nil
            end
            s3 << r12
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(String2)
          r3.extend(String3)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          r0 = r3
        else
          i13, s13 = index, []
          if input.index("'", index) == index
            r14 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("'")
            r14 = nil
          end
          s13 << r14
          if r14
            s15, i15 = [], index
            loop do
              i16, s16 = index, []
              i17 = index
              if input.index("'", index) == index
                r18 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("'")
                r18 = nil
              end
              if r18
                r17 = nil
              else
                self.index = i17
                r17 = SyntaxNode.new(input, index...index)
              end
              s16 << r17
              if r17
                if index < input_length
                  r19 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r19 = nil
                end
                s16 << r19
              end
              if s16.last
                r16 = (SyntaxNode).new(input, i16...index, s16)
                r16.extend(String4)
              else
                self.index = i16
                r16 = nil
              end
              if r16
                s15 << r16
              else
                break
              end
            end
            r15 = SyntaxNode.new(input, i15...index, s15)
            s13 << r15
            if r15
              if input.index("'", index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("'")
                r20 = nil
              end
              s13 << r20
            end
          end
          if s13.last
            r13 = (SyntaxNode).new(input, i13...index, s13)
            r13.extend(String5)
            r13.extend(String6)
          else
            self.index = i13
            r13 = nil
          end
          if r13
            r0 = r13
          else
            self.index = i0
            r0 = nil
          end
        end
      end

      node_cache[:string][start_index] = r0

      return r0
    end

    module Comment0
      def value
        elements[2]
      end

    end

    def _nt_comment
      start_index = index
      if node_cache[:comment].has_key?(index)
        cached = node_cache[:comment][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      s1, i1 = [], index
      loop do
        r2 = _nt_space_no_newline
        if r2
          s1 << r2
        else
          break
        end
      end
      r1 = SyntaxNode.new(input, i1...index, s1)
      s0 << r1
      if r1
        if input.index('#', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('#')
          r3 = nil
        end
        s0 << r3
        if r3
          s4, i4 = [], index
          loop do
            if input.index(Regexp.new('[^\\n]'), index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r5 = nil
            end
            if r5
              s4 << r5
            else
              break
            end
          end
          r4 = SyntaxNode.new(input, i4...index, s4)
          s0 << r4
          if r4
            if input.index("\n", index) == index
              r6 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("\n")
              r6 = nil
            end
            s0 << r6
          end
        end
      end
      if s0.last
        r0 = (AST.create_node(:comment)).new(input, i0...index, s0)
        r0.extend(Comment0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:comment][start_index] = r0

      return r0
    end

    def _nt_blank_line
      start_index = index
      if node_cache[:blank_line].has_key?(index)
        cached = node_cache[:blank_line][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("\n", index) == index
        r0 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("\n")
        r0 = nil
      end

      node_cache[:blank_line][start_index] = r0

      return r0
    end

    def _nt_space_no_newline
      start_index = index
      if node_cache[:space_no_newline].has_key?(index)
        cached = node_cache[:space_no_newline][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index(Regexp.new('[ \\t]'), index) == index
        r0 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r0 = nil
      end

      node_cache[:space_no_newline][start_index] = r0

      return r0
    end

    def _nt_space
      start_index = index
      if node_cache[:space].has_key?(index)
        cached = node_cache[:space][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_space_no_newline
      if r1
        r0 = r1
      else
        if input.index("\n", index) == index
          r2 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("\n")
          r2 = nil
        end
        if r2
          r0 = r2
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:space][start_index] = r0

      return r0
    end

  end

  class GrammarParser < Treetop::Runtime::CompiledParser
    include Grammar
  end

end
