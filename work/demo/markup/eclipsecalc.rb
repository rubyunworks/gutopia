 
#
# eclipsecalc.rb :: model
#

require 'filedialog'

class EclipseCalculator

  attr_reader: file_dialog
  attr_accessor: file_name

  def initialize
  end

  def calc(year, month, day)
    # this would calculate then next eclipse and return the date
  end

  def save
    @file_dialog = FileDialog.new('', @file_name)
  end

  def save_as
    @file_dialog = FileDialog.new('', @file_name)
  end

  def open
    @file_dialog = FileDialog.new('', @file_name)
  end

  def exit
    exit
  end

  def help
  end

  def about
  end

  def statusbar
  end

end
