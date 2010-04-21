# GUtopIa Widget's FXRuby Bindings
# Copyright (c)2002 Thomas Sawyer, Ruby License

require 'fox'
require 'fox/responder'

#
# Copyright (c) 2002 Thomas Sawyer
# License LGPL

include Fox


module GUtopIa
  
  #class Widget < FXObject
  # 
  #end
  
  class Window_Fox < Window
  
    include Responder
  
    attr_reader :engine_widget
  
    def initialize(engine, attributes={})
      super
      
      @engine_widget = FXTopWindow.new(@engine.application, @caption, nil, nil, DECOR_ALL, 0, 0, 0, 0,
        DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_SPACING, DEFAULT_SPACING)
      case @layout_manager
      when :grid
        amatrix = FXMatrix.new(@engine_widget, size=@layout.length, opts=MATRIX_BY_ROWS)
        @layout.each do |row|
          row.each do |colitem|
          puts "===========", colitem.name #, colitem.engine_widget.inspect
            colitem.engine_widget.reparent(amatrix)
          end
        end
      end
    end
    
    def show_core
      super 
      @engine_widget.show(PLACEMENT_SCREEN)
    end
    
  end  # Window


  class Panel_Fox < Panel
  
    include Responder
    
    attr_reader :engine_widget
    
    def initialize(engine, attributes={})
      super
      
    end
  
  end  # Panel


  class Label_Fox < Label
  
    include Responder
    
    attr_reader :engine_widget
    
    def initialize(engine, attributes={})
      super
      
    end
  
  end  # Label
  

  class TextField_Fox < TextField
  
    include Responder
    
    attr_reader :engine_widget
    
    def initialize(engine, attributes={})
      super
      
    end
  
  end  # TextField


  class TextArea_Fox < TextArea
  
    include Responder
  
    attr_reader :engine_widget
  
    def initialize(engine, attributes={})
      super
      
    end
  
  end  # TextArea


  class Button_Fox < Button
  
    include Responder
  
    attr_reader :engine_widget
  
    def initialize(engine, attributes={})
      super
      
    end
  
  end  # Button


  class RadioBox_Fox < RadioBox
    
    attr_reader :engine_widget
  
    def initialize(engine, attributes={})
      super
      
      @engine_widget = FXGroupBox.new(@engine.false_parent, '',
        LAYOUT_SIDE_TOP|FRAME_GROOVE|LAYOUT_FILL_X, 0, 0, 0, 0)
      
      @fxrbs = []
      items.each_with_index do |item, i|
        @fxrbs[i] = FXRadioButton.new(@engine_widget, item, nil, 0,
          JUSTIFY_LEFT|JUSTIFY_TOP|ICON_BEFORE_TEXT|LAYOUT_SIDE_TOP)
        @fxrbs[i].connect(SEL_COMMAND) { 
          if @fxrbs[i].getCheck
            @value = @fxrbs[i].to_s
            self.value = @fxrbs[i].to_s
            event_change
          end
        }
      end
    
    end

    def value_=(v)
      @fxrbs.each do |fxrb|
        #puts fxrb.gettype().inspect
        if fxrb.to_s == v
          fxrb.setCheck(true)
        else
          fxrb.setCheck(false)
        end
        #fxrb.setTarget(fxrb)
      end
    end
    
  end  # RadioBox
  
  
  class MenuBar_Fox < MenuBar
  
    include Responder
    
    attr_reader :engine_widget
    
    def initialize(engine, attributes={})
      super
    
    end
  
  end  # MenuBar
  
  
  class Menu_Fox < Menu
  
    include Responder
    
    attr_reader :engine_widget
    
    def initialize(engine, attributes={})
      super
      
    end
  
  end  # Menu


  class MenuItem_Fox < MenuItem
  
    include Responder
  
    attr_reader :engine_widget
  
    def initialize(engine, attributes={})
      super
    
    end
  
  end  # MenuItem

end  # GUtopIa
