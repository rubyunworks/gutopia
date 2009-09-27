# GUtopIa - ROMP Daemon
# Copyright (c) 2002 Thomas Sawyer, Ruby License

require 'romp/romp'
require 'gutopia'

gutopiad = GUtopIa::GUI.new('Romp')

server = ROMP::Server.new('tcpromp://localhost:8080', nil, true)
server.bind(gutopiad, 'gutopia-romp')
server.thread.join
