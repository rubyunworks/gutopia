# GUtopIa Daemon Example - Client
# Copyright (c) 2002 Thomas Sawyer, Ruby License

require 'romp/romp'
require 'example-app'
require 'example-pre'


# Configure interface

INTERFACE = 'PDA'
puts "\nINTERFACE: #{INTERFACE}\n"


# Make GUI App

fruitapp = FruitApp.new

client = ROMP::Client.new('tcpromp://localhost:8080')
mygui = client.resolve('gutopia-romp')

names = {
  'awindow' => fruitapp.appname,
  'aradio'  => fruitapp.fruitbasket.name
}

bindings = {
  fruitapp.fruitbasket.name => { 
    :value        => Proc.new { fruitapp.fruit.isa },
    :value=       => Proc.new { |x| fruitapp.fruit.isa = x },
    :items        => Proc.new { fruitapp.fruitbasket.contains },
    :event_change => Proc.new { fruitapp.pickafruit }
  }
}

model = MyModels.pick_model(mygui, INTERFACE)

mygui.transaction(bindings, names, &model)

mygui.build


# Run some tests

puts
puts "MYGUI "
p mygui

puts
puts "MYGUI WIDGETS"
mygui.widgets.each_key do |k|
  puts k
end

puts
puts "THE WINDOW"
p mygui.widgets[fruitapp.appname].class.superclass
puts "name: #{fruitapp.appname}"
puts "width: #{mygui.widgets[fruitapp.appname].width}"
puts "height: #{mygui.widgets[fruitapp.appname].height}"

puts
puts "THE RADIO"
p mygui.widgets[fruitapp.fruitbasket.name].class.superclass
puts "name: #{fruitapp.fruitbasket.name}"
puts "items: #{mygui.widgets[fruitapp.fruitbasket.name].items.join(', ')}"
puts "value: #{mygui.widgets[fruitapp.fruitbasket.name].value}"

puts
puts
puts "TRY OUT!"
puts
puts "Current state of fruit and its widget:"
puts "fruit=#{fruitapp.fruit.isa}"
puts "widget=#{mygui.widgets[fruitapp.fruitbasket.name].value}"
puts
puts "Changing widget to: #{mygui.widgets[fruitapp.fruitbasket.name].value = 'Banana'}"
puts "fruit=#{fruitapp.fruit.isa}"
puts
puts "Changing fruit to: #{fruitapp.fruit.isa = 'Orange'}"
puts "widget=#{mygui.widgets[fruitapp.fruitbasket.name].value}"
puts
puts "Trigger event_change event:"
mygui.widgets[fruitapp.fruitbasket.name].event_change
puts
puts "Changing fruit to: #{fruitapp.fruit.isa = 'Apple'}"
puts "widget=#{mygui.widgets[fruitapp.fruitbasket.name].value}"
puts
puts "Changing widget to: #{mygui.widgets[fruitapp.fruitbasket.name].value = 'Banana'}"
puts "fruit=#{fruitapp.fruit.isa}"

puts
