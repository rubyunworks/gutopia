# GUtopIa Example - Presentation
# Copyright (c) 2002 Thomas Sawyer, Ruby License

require 'gutopia'
require 'example-app'

# Make GUI App

#gui = GUtopIa.new

model = FruitApp.new

view = GUtopIa::View.new {

  # RadioBox
  @aradio = radiobox
  
  # Window
  @awindow = window {
    width  320
    height 200
    layout :grid
    body   [ [ :aradio ] ]
  }

}

puts view.awindow.depth(16).width(100)
puts view.awindow.depth
puts view.awindow.width
puts view.aradio.value


controller = GUtopIa::Controller.new {
  
  view.aradio.value { model.fruit.isa }
  view.aradio.value { |x| model.fruit.isa = x }
  view.aradio.items { model.fruitbasket.contains }
  view.aradio.event_change { model.pickafrut }
  
    bind(:value=)       { |x| model.fruit.isa = x }
    bind(:items)        { model.fruitbasket.contains }
    bind(:event_change) { model.pickafruit }
  }

  bind_model(model.fruit) {
    bindback(:isa=) { |x| view.aradio.value(x) }
  }

}

=begin

controller = GUtopIa::Controller.new {
  
  bind_view(view.aradio) {
    bind(:value)        { model.fruit.isa }
    bind(:value=)       { |x| model.fruit.isa = x }
    bind(:items)        { model.fruitbasket.contains }
    bind(:event_change) { model.pickafruit }
  }

  bind_model(model.fruit) {
    bindback(:isa=) { |x| view.aradio.value(x) }
  }

}

gui.build(model, view, controller)


# Run some tests

puts
puts "MYGUI "
p gui

exit

puts
puts "MYGUI WIDGETS"
gui.widgets.each_key do |k|
  puts k
end

puts
puts "THE WINDOW"
p myapp.widgets[fruitapp.appname].class.superclass
puts "name: #{fruitapp.appname}"
puts "width: #{myapp.widgets[fruitapp.appname].width}"
puts "height: #{myapp.widgets[fruitapp.appname].height}"

puts
puts "THE RADIO"
p myapp.widgets[fruitapp.fruitbasket.name].class.superclass
puts "name: #{fruitapp.fruitbasket.name}"
puts "items: #{myapp.widgets[fruitapp.fruitbasket.name].items.join(', ')}"
puts "value: #{myapp.widgets[fruitapp.fruitbasket.name].value}"

puts
puts
puts "TRY OUT!"
puts
puts "Current state of fruit and its widget:"
puts "fruit=#{fruitapp.fruit.isa}"
puts "widget=#{myapp.widgets[fruitapp.fruitbasket.name].value}"
puts
puts "Changing widget to: #{myapp.widgets[fruitapp.fruitbasket.name].value = 'Banana'}"
puts "fruit=#{fruitapp.fruit.isa}"
puts
puts "Changing fruit to: #{fruitapp.fruit.isa = 'Orange'}"
puts "widget=#{myapp.widgets[fruitapp.fruitbasket.name].value}"
puts
puts "Trigger event_change event:"
myapp.widgets[fruitapp.fruitbasket.name].event_change
puts
puts "Changing fruit to: #{fruitapp.fruit.isa = 'Apple'}"
puts "widget=#{myapp.widgets[fruitapp.fruitbasket.name].value}"
puts
puts "Changing widget to: #{myapp.widgets[fruitapp.fruitbasket.name].value = 'Banana'}"
puts "fruit=#{fruitapp.fruit.isa}"

puts

myapp.thread.join

=end