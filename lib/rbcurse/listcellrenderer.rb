require 'rubygems'
require 'ncurses'
require 'logger'
require 'lib/rbcurse/rwidget'
module RubyCurses

  ## 
  # This is a basic list cell renderer that will render the to_s value of anything.
  # Using alignment one can use for numbers too.
  # However, for booleans it will print true and false. If editing, you may want checkboxes
  class ListCellRenderer
    #include DSL
    #include EventHandler
    include RubyCurses::ConfigSetup
    include RubyCurses::Utils
    dsl_accessor :justify     # :right, :left, :center  # added 2008-12-22 19:02 
    dsl_accessor :display_length     #  please give this to ensure the we only print this much
    dsl_accessor :height    # if you want a multiline label.
    dsl_accessor :text    # text of label
    dsl_accessor :color, :bgcolor
    dsl_accessor :row, :col
    dsl_accessor :parent    #usuall the table to get colors and other default info

    def initialize text="", config={}, &block
      @text = text
      @editable = false
      @focusable = false
      config_setup config # @config.each_pair { |k,v| variable_set(k,v) }
      instance_eval &block if block_given?
      init_vars
    end
    def init_vars
      @justify ||= :left
      @display_length ||= 10
    end
    def getvalue
      @text
    end
    ##
    # sets @color_pair and @attr
    def prepare_default_colors focussed, selected
        @color_pair = get_color $datacolor
        #acolor =get_color $datacolor, @color || @parent.color, @bgcolor || @parent.bgcolor #unless @parent.nil?
        @attr = Ncurses::A_NORMAL


        ## determine bg and fg and attr
        if selected
          @attr = Ncurses::A_BOLD if selected
          @color_pair =get_color $selectedcolor, @parent.selected_color, @parent.selected_bgcolor unless @parent.nil?
        end
        if focussed 
          @attr |= Ncurses::A_REVERSE
        end
    end

    ##
    # 
    def repaint graphic, r=@row,c=@col, value=@text, focussed=false, selected=false
        #$log.debug "label :#{@text}, #{value}, #{r}, #{c} col= #{@color}, #{@bgcolor} acolor= #{acolor} j:#{@justify} dlL: #{@display_length} "

      prepare_default_colors focussed, selected

        lablist = []
        value=value.to_s # ??
        if @height && @height > 1
          lablist = wrap_text(value, @display_length).split("\n")
        else
          # ensure we do not exceed
          if !@display_length.nil?
            if value.length > @display_length
              value = value[0..@display_length-1]
            end
          end
          lablist << value
        end
        len = @display_length || value.length
        _height = @height || 1
        str = @justify.to_sym == :right ? "%*s" : "%-*s"  # added 2008-12-22 19:05 
        # loop added for labels that are wrapped.
        # clear separately since value can change in status like labels
        #len -= @left_margin
        0.upto(_height-1) { |i| 
          graphic.printstring r+i, c, ( " " * len) , @color_pair,@attr
        }
        lablist.each_with_index do |_value, ix|
          break if ix >= _height
          if @justify.to_sym == :center
            padding = (@display_length - _value.length)/2
            _value = " "*padding + _value + " "*padding # so its cleared if we change it midway
          end
          graphic.printstring r, c, str % [len, _value], @color_pair,@attr
          r += 1
        end
    end
  # ADD HERE 
  end
end
