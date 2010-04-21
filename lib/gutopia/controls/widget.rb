module GUtopIa

  #
  class Widget

    #
    def self.adapter(object)
      GUtopIa.gui.const_get(object.class.name.split('::').last)
    end

    #
    def initialize(*args, &blk)
      @adapter = Widget.adapter(self).new(*args, &blk)
    end

  end

end
