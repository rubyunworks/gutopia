 
#
# filedialog.rb
#

class FileDialog

  attr_reader :directory_tree, :file_list, :directory, :file_name

  def initialize(current_directory = '', current_file_name = '')
    @directory = current_directory
    @file_name = current_file_name
    # build directory tree
    ...
    # build file list
    ...
  end

  def ok
    return File.join(directory, file_name)
  end

  def cancel
    return nil
  end

end