# GUtopIa - Sample
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

require 'yaml'

require 'gutopia/gutopia'
require 'sample1-model'

# create model, view and application
model = FruitApp.new
view = GUtopIa::View.new('gtk')
application = GUtopIa::Application.new

# define components

aradio = GUtopIa::RadioBox.new

abutton = GUtopIa::Button.new
abutton.text = 'Quit'

awindow = GUtopIa::Window.new
awindow.width = 200
awindow.height = 300
awindow.layout = :grid
awindow.body =  [ [ aradio  ],
                  [ abutton ] ]

# define the interrelation between model and components

awindow.caption = model.appname
aradio.value = model.fruit.isa
aradio.items = model.fruitbasket.contains

aradio.when(:value=) { |x| model.fruit.isa = x; model.pickafruit }
model.fruit.when(:isa=) { |x| aradio.value = x }
aradio.when(:change) { model.pickafruit }
abutton.when(:press) { 
  model.pickafruit
  application.stop
}

# register the components with the view
view.register {
  @fruitbasket = aradio
  @fruitbutton = abutton
  @fruitwindow = awindow
}

# register the view with the application
application.register {
  @fruitview = view
}

model.pickafruit

# start application
application.start {
  fruitview.fruitwindow.show
}
