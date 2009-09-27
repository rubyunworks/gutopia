# GUtopIa API
# Copyright (c)2002 Thomas Sawyer, Ruby License

require 'gutopia/components'

module GUtopIa

  #
  class View
  
    def initialize(&view_proc)
      instance_eval(&view_proc)
      instance_variables.each do |v|
        instance_eval <<-EOS
          if #{v}.kind_of?(Component)
            def #{v[1..-1]}
              return #{v}
            end
          end
        EOS
      end
    end

    def method_missing(methId, *args, &block)
      return Component.instance(methId, &block)
    end

  end

end







=begin  
  

  #
  class Controller
  
    def initialize(&bind_proc)
      #@_components = {}
      instance_eval(&bind_proc)
    end

    def method_missing(component, *args, &block)
      if args.length == 0
        if @_components.has_key?(component)
          return @_components[component]
        else
          return nil
        end
      else
        @_components[component] = Component.new(component)
      end
    end

  end



end



  def GUtopIa.new
    
    #require 'gutopia-fox'
    #require 'widgets-fox'
    #return GUI_Fox.new(name, vendor, '_Fox')
    
    return GUI.new('none', 'none', '')
    
  end

  # Returns a GUI object
  class GUI

    attr_reader :names, :vendor, :widgets

    def initialize(name, vendor, platform)
      @name = name
      @vendor = vendor
      #
      @widgets = {}
      #
      @engine = GUtopIa.const_get("PlatformEngine#{platform}").new(name, vendor)
    end


    def view(&view_block)
      Proc.new(&view_block)
    end


    def controller(&control_block)
      Proc.new(&control_block)
    end


    def bind(arg=nil, &p)
      if not arg.is_a?(Symbol)
        @working_obj = arg
        yield
      else
        # enhance app objects
        obj = @working_obj
        msg = arg
        meth = obj.method(msg)  # get the object method
        mod = Module.new        # make a module with redefined method
        mod.module_eval { 
          define_method(msg) { |*args|
            meth.call(*args)
            p.call(*args)
          }
        }
        obj.extend mod          # extend the object with the new method
      end
    end


    def bindback(arg=nil, &p)
      if not arg.is_a?(Symbol)
        @working_obj = arg
        yield
      else
        # enhance app objects
        obj = @working_obj
        msg = arg
        meth = obj.method(msg)  # get the object method
        mod = Module.new        # make a module with redefined method
        mod.module_eval { 
          define_method(msg) { |*args|
            meth.call(*args)
            p.call(*args)
          }
        }
        obj.extend mod          # extend the object with the new method
      end
    end


    # Method used to build GUI
    def build(model, view, controller)
      instance_eval(&view)
      instance_eval(&controller)
    end


    def [](widget)
      return @widgets[widget]
    end


    # Widget Factory
    #   Returns a new widget object of specialized widget class
    def widgetFactory(widget, attributes={})
      
      # a widget string name will work too
      widget = widget.intern if widget.is_a?(String)
       
      # makes an anoynomous class as subclass of desired widget
      widgetClassName = (widget.id2name + @engine.suffix).intern
      widgetClass = Class.new(GUtopIa.const_get(widgetClassName))
    
      # specialize class via bindings
      #if @bindings[@names[name] || name]
      #  @bindings[@names[name] || name].each do |m, p|
      #    widgetClass.class_eval {
      #      define_method(m, p)
      #    }
      #  end
      #end
        
      w = widgetClass.new(@engine, attributes)
      #w.name = @names[name] || name
      #@widgets[w.name] = w
      
      return w
      
    end

    #
    def alert(msg)
      puts msg
    end

    #
    def stop
      puts "stopping...#{@name}"
      exit
    end


    # Useful Class Methods?
    
    def GUI.screen_realestate
      # { :height => , :width => , :depth => }
    end
    
  end  # GUI


  class PlatformEngine
  
    attr_reader :suffix #:application, :main_window, :false_parent
  
    def initialize(name, vendor)
      @suffix = ''
      #@application = FXApp.new(name, vendor)
      #@main_window = FXMainWindow.new(@application, name, nil, nil, DECOR_ALL)
      #@false_parent = FXTopWindow.new(@application, 'false_parent', nil, nil, DECOR_ALL, 0, 0, 0, 0,
      #  DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_SPACING, DEFAULT_SPACING)
    end
  
  end
  
  
end  # GUtopIa

=end