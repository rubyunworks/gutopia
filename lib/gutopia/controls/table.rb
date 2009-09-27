module GUtopIa

  class Table

    attr :name
    attr :connection
    attr :headers

    def initialize(name, *connection, &headers)
      @name       = name
      @connection = connection
      @headers    = headers.call
    end

  end

end

