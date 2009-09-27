module Utopia

  def Utopia.new_application(name)
    Application.new(name)
  end
  
  def Utopia.modeller_class
    Modeller
  end
  
  def Utopia.controller_class=(controller)
    @controller = controller
  end
  
  def Utopia.controller_class
    @controller
  end
  
  def Utopia.register_platform(platform, &block)
    Modeller.instance.register_platform(platform, &block)
  end

  class Modeller
    attr_reader :current_platform
    
    def initialize
      @platforms = {}
      @current_platform = :Common
    end
    
    def current_platform=(platform)
      platform = platform.intern unless platform.kind_of? symbol
      raise "Unknown platform #{platform.to_s}" unless @platforms.include? platform
      @current_platform = platform
    end
    
    def Modeller.instance
      @instance ||= Modeller.new
      return @instance
    end
    
    def build(component, platform=nil, name=nil)
      platform ||= @current_platform
      raise "Unknown platform #{platform}" unless @platforms.include? platform
      componentDef = @platforms[platform][component]
      componentDef = @platforms[:Common][component] unless componentDef
      raise "Unknown component #{component.to_s} on platform #{platform}" unless componentDef
      return Component.new(name, componentDef)
    end
    
    def register_platform(platform, &block)
      @platforms[platform]=PlatformDef.new(platform, &block)
    end
  end
  
  class PlatformDef
    attr_reader :platform
    def initialize(platform, &block)
      @platform = platform
      @components = {}
      instance_eval(&block) if block_given?
    end
    
    def add_component(component, &block)
      @components[component] = ComponentDef.new(component, &block)
    end
    
    def has_component?(component)
      return @components.has_key? component
    end
    
    def [](component)
      return @components[component]
    end
  end
  
  class ComponentDef
    attr_reader :name
    def initialize(name, &block)
      @name = name
      @attributes = {}
      instance_eval(&block) if block_given?
    end
    
    def add_attribute(attribute, default=nil, &validator)
      @attributes[attribute]=AttributeDef.new(attribute, default, &validator)
    end
    
    def has_attribute?(attribute)
      return @attributes.has_key? attribute
    end
    
    def [](attribute)
      return @attributes[attribute]
    end
    
  end
  
  class AttributeDef
    attr_reader :name, :default
    def initialize(name, default=nil, &validator)
      @name = name
      @default = default
      @validator = validator if validator
    end
    
    def validate(value)
      if @validator
        raise "Illegal value for #{@name} : #{value}" unless @validator.call(value)
      end
      value
    end
  end
  
  class Application
    attr_reader :name, :modeller, :controller
    def initialize(name)
      @name = name
      @modeller = Utopia.modeller_class.instance
      @controller = Utopia.controller_class.new(self)
    end
  end
  
  class Container
    def initialize(platform, &block)
      @_platform = platform
      @_components = []
      @_component_map = {}
      instance_eval(&block) if block_given?
    end
    
    def method_missing(name, *args, &block)
      return @_component_map[name] if @_component_map.has_key? name
      if args[0].kind_of? Container
        @_components.push args[0]
        @_component_map[name] = args[0]
        return args[0]
      end
      component = Utopia.modeller_class.instance.build(args[0], @_platform, name)
      @_components.push component
      @_component_map[name] = component
      return component
    end
  end

  class Component
    attr_reader :_type, :_name
    
    def initialize(name, componentDef)
      @_componentDef = componentDef
      @_name = name
      @_events = {}
      @_values = {}
    end
    
    def method_missing(attribute, *args, &block)
      attribute = attribute.to_s[0..-2].intern if attribute.to_s[-1]==61 #61 is an equals '='
      raise "Illegal attribute #{attribute} for #{@_name}" unless @_componentDef.has_attribute? attribute
      unless (args.length>0 or block_given?)
        return @_values.has_key?(attribute) ? @_values[attribute] : @_componentDef[attribute].default
      end
      if block_given?
        platform = args[0] if args.length == 1
        platform = Utopia.modeller_class.instance.current_platform unless platform
        @_values[attribute] = @_componentDef[attribute].validate(Container.new(platform, &block))
        return self
      end
      @_values[attribute] = @_componentDef[attribute].validate(args[0])
      self
    end
    
    def bind_event(event, &handler)
      @_events[event] = handler
    end
    
    def fire_event(event, *args, &block)
      @_events[event].call(*args, &block)
    end
    
    def to_s
      return @_name
    end
  end  
end

module Utopia
  module Definitions
    
    ##
    # Register the Common platform widget set
    #
    #
    Utopia.register_platform(:Common) {
      add_component(:textarea) {
        add_attribute(:cols, 20) {|value| value.kind_of? Fixnum}
        add_attribute(:lines, 3) {|value| value.kind_of? Fixnum}
        add_attribute(:readonly, false) {|value| value==true or value==false}
        add_attribute(:label)
        add_attribute(:label_position, :left) {|value| value==:left || value==:right || value==:top || value==:bottom}
      }
      add_component(:button) {
        add_attribute(:text)
        add_attribute(:image)
      }
      add_component(:icon) {
        add_attribute(:file)
      }
      add_component(:label) {
        add_attribute(:text)
      }
      add_component(:table) {
        add_attribute(:cols, 4) {|value| value.kind_of? Fixnum}
        add_attribute(:rows, 4) {|value| value.kind_of? Fixnum}
        add_attribute(:border, :raised) {|value| value==:raised or value==:etched}
        add_attribute(:border_title)
        add_attribute(:data)
      }
      add_component(:textfield) {
        add_attribute(:text)
        add_attribute(:cols, 4) {|value| value.kind_of? Fixnum}
        add_attribute(:readonly, false) {|value| value==true or value==false}
        add_attribute(:label)
        add_attribute(:label_position, :left) {|value| value==:left || value==:right || value==:top || value==:bottom}
      }
      add_component(:passwordfield) {
        add_attribute(:text)
        add_attribute(:cols, 4) {|value| value.kind_of? Fixnum}
        add_attribute(:mask, '*')
      }
      add_component(:menubar) {
        add_attribute(:items) {|value| value.kind_of? Container}
      }
      add_component(:menu) {
        add_attribute(:text)
        add_attribute(:items) {|value| value.kind_of? Container}
      }
      add_component(:menuitem) {
        add_attribute(:text)
      }
      add_component(:panel) {
        add_attribute(:body) {|value| value.kind_of? Container}
      }
      add_component(:window) {
        add_attribute(:title)
        add_attribute(:body) {|value| value.kind_of? Container}
      }
      add_component(:dialog) {
        add_attribute(:title)
        add_attribute(:modal, false) {|value| value==true or value==false}
        add_attribute(:body) {|value| value.kind_of? Container}
      }
    }
    
    ##
    # Register the Win32 Platform to add the coolbar widget
    #
    #
    Utopia.register_platform PlatformDef.new(:Win32) {
      add_component(:coolbar) {
        add_attribute(:items, 20) {|value| value.kind_of? Container}
      }
    }
  end
end


class Valhalla
  def initialize(app)
    @app = app
  end
  
  def start(&block)
    puts "main loop started for...#{@app.name}"
    instance_eval(&block)
  end
  
  def show(component)
    puts "showing...#{component.title}"
  end
  
  def hide(component)
    puts "hiding...#{component.title}"
  end
  
  def stop
    puts "stopping main loop for....#{@app.name}"
  end
end
Utopia.controller_class = Valhalla
