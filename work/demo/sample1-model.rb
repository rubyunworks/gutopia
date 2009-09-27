# GUtopIa - Sample Data Model
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

class FruitApp
  attr_accessor :appname
  attr_reader :fruitbasket, :fruit, :basketname
  def initialize
    @appname = 'Fruity Fun Time'
    @fruitbasket = FruitBasket.new
    @fruit = Fruit.new
  end
  def pickafruit
    puts "You got a #{@fruit.isa}!"
  end
end

class FruitBasket
  attr_accessor :name, :contains
  def initialize
    @name = 'Fruit Basket'
    @contains = ["None", "Apple", "Orange", "Banana"]
  end
end

class Fruit
  attr_accessor :isa
  def initialize
    @isa = "None"
  end
end
