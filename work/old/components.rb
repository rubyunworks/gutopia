# GUtopIa - Components
# Copyright (c) 2002 Thomas Sawyer

# GUtopIa is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# GUtopIa is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with GUtopIa; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

module GUtopIa
  
  # MIXIN MODULES
  
  module Layout
    attribute(:layout)      { |value| value.kind_of?(Symbol) }
    attribute(:body)        { |value| value.kind_of?(Array) }
  end
  
  module Labeled
    attribute(:label)       { |value| value.kind_of?(String) }
  end
  
  module Iconed
    attribute(:icon)
  end
  
  module Columned
    attribute(:columns)     { |value| value.kind_of?(Fixnum) }
    attribute(:headers)     { |value| value.kind_of?(Array) }
  end
  
  module ListSelection
    attribute(:value)       { |value| value.kind_of?(String) }
    attribute(:index)       { |value| value.kind_of?(Fixnum) }
    attribute(:lines)       { |value| value.kind_of?(Fixnum) }
    attribute(:items)       { |value| value.kind_of?(Array) }
    attribute(:multiple)    { |value| value.kind_of?(TrueClass) ||  value.kind_of?(FalseClass) }
    
    event(:select)
  end
  
  module RangeSelection
    attribute(:value)       { |value| value.kind_of?(Float) }
    attribute(:min)         { |value| value.kind_of?(Float) }
    attribute(:max)         { |value| value.kind_of?(Float) }
    attribute(:position)    { |value| value.kind_of?(Float) }
    attribute(:ratio)       { |value| value.kind_of?(Float) }
    
    event(:change)
  end
  
  module KeyboardEntry
    attribute(:value)       { |value| value.kind_of?(String) }
    attribute(:read_only)   { |value| value.kind_of?(TrueClass) ||  value.kind_of?(FalseClass) }
    attribute(:maxlength)   { |value| value.kind_of?(Fixnum) }
    attribute(:maxlines)    { |value| value.kind_of?(Fixnum) }
    
    event(:change)
  end
  
  module KeyboardPress
    event(:press)
    event(:key_up)
    event(:key_down)
  end
  
  module PointerPresence
    event(:pointer_in)
    event(:pointer_out)
  end
  
  module PointerMotion
    event(:pointer_move)
  end
  
  module PointerButton
    event(:click)
    event(:double_click)
    event(:pointer_up)
    event(:pointer_down)
  end
  
  module FocusReceiver
    event(:focus_in)
    event(:focus_out)
  end
  
  
  # SUPER CLASSES
  
  class Component
  
    PRECEDENCE = [ :Label,
                   :Text,
                   :Button,
                   :RadioBox,
                   :ListBox,
                   :TextList,
                   :MenuItem,
                   :Menu,
                   :MenuBar,
                   :Panel,
                   :Window
    ]
    
    def Component.attribute(name, &valid)
      methid = name.to_s
      if not block_given?
        validator = Proc.new { true }
      else
        validator = valid
      end
      class_eval <<-EOS
        if not method_defined?(:#{methid}=)
          def #{methid}=(arg)
            return @#{methid} if @#{methid} == arg
            if #{validator}.call(arg)
              @#{methid} = arg
              @platform_component.send(:#{methid}=, arg) if @platform_component.respond_to?(:#{methid}=) and @platform_component
              return @#{methid}
            else
              raise "invalid argument value"
            end
          end
        end
        if not method_defined?(:#{methid})
          def #{methid}(*args)
            if args.length > 0
              self.#{methid} = args[0]
              return self
            else
              return @#{methid}
            end
          end
        end
      EOS
    end
  
    def Component.event(name)
      methid = name.to_s
      if not block_given?
        action = Proc.new {}
      else
        action = act
      end
      class_eval <<-EOS
        if not method_defined?(:#{methid})
          def #{methid}
            @platform_component.send(:#{methid}) if @platform_component.respond_to?(:#{methid}) and @platform_component
          end
        end
      EOS
    end
  
    attr_reader :platform_component
  
    def initialize(attr_hash=nil, &block)
      #
      if attr_hash
        attr_hash.each do |k, v|
          send(k.to_s.intern, v)
        end
      end
      if block_given?
        instance_eval(&block)
      end
    end
    
    # create the platform specific component
    def create
      comp_symbol = self.class.name.gsub(/^.*::/,'').intern
      @platform_component = Platform.const_get(comp_symbol).new(self)
    end
    
    def <=>(component)
      self_symbol = self.type.name.gsub(/^.*::/,'').intern
      comp_symbol = component.type.name.gsub(/^.*::/,'').intern
      PRECEDENCE.index(self_symbol) <=> PRECEDENCE.index(comp_symbol)
    end
    
  end
  
  
  class Widget < Component
    
    attribute(:top)        { |value| value.kind_of?(Fixnum) }
    attribute(:left)       { |value| value.kind_of?(Fixnum) }
    attribute(:width)      { |value| value.kind_of?(Fixnum) }
    attribute(:height)     { |value| value.kind_of?(Fixnum) }
    
    event(:show)
    event(:hide)
    event(:size)
    event(:move)
  
  end
  
  
  # CLASSES
  
  class Window < Widget
  
    include Layout
    include Labeled
    include Iconed
    
    attribute(:depth)      { |value| value.kind_of?(Fixnum) }
    attribute(:flags)      { |value| value.kind_of?(Fixnum) }
    attribute(:background) { |value| value.kind_of?(Fixnum) }
    attribute(:layout)     { |value| value.kind_of?(Symbol) }
    attribute(:body)       { |value| value.kind_of?(Array) }
    
    event(:close)
    
    def initialize(attr_hash=nil, &block)
      @width = 320
      @height = 200
      @depth = 24
      @flags = 0
      @caption = ''
      @icon = nil
      @background = nil
      @layout = :grid
      @body = []
      super
    end
    
  end  # Window

  
  class Panel < Widget
  
    include Layout
    include Labeled

    attribute(:borderstyle) { |value| value.kind_of?(Symbol) }
    attribute(:borderwidth) { |value| value.kind_of?(Fixnum) }
    
    def initialize(attr_hash=nil, &block)
      @width = 320
      @height = 200
      @background = nil
      @layout = :grid
      @body = []
      @caption = ''
      @borderstyle = :none
      @borderwidth = 0
      super
    end
    
  end  # Panel


  class Button < Widget
  
    include Labeled
    include Iconed
    include KeyPress
    include PointerButton
    include PointerPresence

    def initialize(attr_hash=nil, &block)
      @label = ''
      @image = nil
      super
    end
    
  end  # Button
  
  
  class Label < Widget
  
    include Labeled
    
    def initialize(attr_hash=nil, &block)
      @label = ''
      super
    end  
    
  end  # Label
  

  class Text < Widget
    
    include KeyboardEntry

    def initialize(attr_hash=nil, &block)
      @value = ''
      @columns = 25
      @lines = 1
      @readonly = false
      super
    end
    
  end  # Text

  
  class TextList < Widget
  
    include KeyboardEntry
    include ListSelection

    def initialize(attr_hash=nil, &block)
      @value = ''
      @items = []
      @lines = 8
      super
    end
    
  end  # TextList
  
  
  class ListBox < Widget
  
    include ListSelection
  
    def initialize(attr_hash=nil, &block)
      @value = ''
      @items = []
      @lines = 4
      @columns = 1
      @headers = []
      super
    end
    
  end  # ListBox
  
  
  class RadioBox < Widget
  
    include ListSelection
    
    def initialize(attr_hash=nil, &block)
      @value = ''
      @items = []
      super
    end
    
  end  # RadioBox
  

  class MenuBar < Widget
  
    attribute(:items)

    def initialize(attr_hash=nil, &block)
      @items = []
      super
    end
    
  end  # MenuBar
  
  
  class Menu < Widget
  
    attribute(:text)
    attribute(:items)
  
    def initialize(attr_hash=nil, &block)
      @text = ''
      @items = []
      super
    end
    
  end  # Menu


  class MenuItem < Widget
  
    include Iconed
    
    attribute(:text)

    event(:press)
  
    def initialize(attr_hash=nil, &block)
      @text = ''
      @icon = nil
      super
    end
  
  end  # MenuItem

end  # GUtopIa

