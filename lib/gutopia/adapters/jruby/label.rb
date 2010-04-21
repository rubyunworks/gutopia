module GUtopIa
  module Adapters
    module JRuby

      #
      class Label

        #
        def initialize(text)
          @widget = javax.swing.JLabel.new(text)
        end

        #
        def text
          @widget.get_text
        end

        #
        def text=(string)
          @widget.set_text(string)
        end

      end

    end
  end
end

