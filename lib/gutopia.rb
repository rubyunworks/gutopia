module GUtopIa

  def self.gui
    Adapters::JRuby
  end

  def self.gui_load
    require(File.dirname(__FILE__) + '/gutopia/adapters/jruby')
  end

end

require 'gutopia/controls/widget'
require 'gutopia/controls/window'
require 'gutopia/controls/layout'
require 'gutopia/controls/label'

GUtopIa.gui_load

