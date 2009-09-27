

class Person
  attr_accessor :lastname, :favoritefruit, :firstname
end

person = Person.new


require 'utopia'

app = Utopia.new_application("My Application")

aboutWindow = nil
mainWindow = nil

mainWindow = app.modeller.build(:window).title("My Cool Window").body {

  icon(:icon).file('myIcon.ico')

  menu(:menubar).items {
  
    file(:menu).text('File').items {
      quit(:menuitem).text('Quit')
      quit.when(:selected) do
        app.controller.stop
      end
    }
    
    help(:menu).text('Help').items {
      about(:menuitem).text('About')
      about.when(:selected) do
        app.controller.show aboutWindow
      end
    }
    
  }
  
  fruit_panel(:panel).body {
  
    first_name(:textfield)
    first_name.label("First name:").label_position(:left)
    first_name.bind_attribute(:text, person, :firstname)
    
    last_name(:textfield)
    last_name.label("Last name:").label_position(:left)
    last_name.bind_attribute(:text, person, :lastname)
    
    favorite_fruit(:textarea)
    favorite_fruit.cols(5).lines(4).readonly(false)
    favorite_fruit.label("Favorite Fruit:").label_position(:top)
    favorite_fruit.bind_attribute(:text, person, :favoritefruit)
    
    submit(:button).text('Update').image('check.png')
    submit.when(:pressed) do
      app.controller.alert "And the fruit is....#{favoriteFruit.text}"
      app.controller.hide mainWindow
      app.controller.end
    end
    clear(:button).text('Clear')
    clear.when(:pressed) do
      favoriteFruit.text=nil
    end
    
  }
  
}

aboutWindow = app.modeller.build(:window).title("About My Cool App").body {
  
  about(:label).text = <<-DATA
  This is a very cool application
  that I created using the Utopia
  GUI API.
  DATA
  
  close(:button).text("Close")
  close.when(:pressed) do
    app.controller.hide aboutWindow
  end
  
}

app.controller.start {
  show mainWindow
}

puts "click on about"
mainWindow.body.menu.items.help.items.about.event(:selected)

puts "click on close"
aboutWindow.body.close.event(:pressed)

puts "Updating data attribute by updating textbox"
mainWindow.body.fruit_panel.body.first_name.text="richard"
puts "person value: "+person.firstname

puts "Updating textbox by updating data attribute"
person.firstname="yokum"
puts "text box value "+mainWindow.body.fruit_panel.body.first_name.text

puts "select close from menu"
mainWindow.body.menu.items.file.items.quit.event(:selected)


