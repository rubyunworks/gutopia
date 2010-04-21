# GUtopIa - ROMP Daemon
# Copyright (c) 2002 Thomas Sawyer, Ruby License

require 'drb'
require 'gutopia'

gutopia_drb = GUtopIa::GUI.new('DRb')

DRb.start_service('druby://localhost:8080', gutopia_drb)
DRb.thread.join
