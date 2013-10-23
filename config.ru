require 'sinatra/base'
require 'koala'
require 'active_record'
require 'rubygems'
require 'yaml'
require 'sinatra/activerecord'
require './models/init.rb'
require './helpers/init.rb'
require './controllers/app.rb'

map('/app')

##########################################################################
# The Rack DSL offers a third method besides `use` and `run`: map. 
# This nifty method allows you to map a given path to a Rack endpoint. 
# We can use that to serve multiple Sinatra apps from the same process
#
# Rack will remove the path supplied to map from the request path and 
# store it safely in env['SCRIPT_NAME']. 
#
# Sinatra’s url helper will pick it up to construct correct links for you.
##########################################################################

# require './app'
# run ApplicationController

# config.ru allows the application to be run from the command line using: `rackup`
# Not ideal though for development as we'll likely want to use the Shotgun gem

# Note: 
# If we're writing a modular Sinatra app then for us to be able to use the Shotgun gem we need to run `bundle exec shotgun`
# If we're writing a classic Sinatra app then this file needs to use `run Sinatra::Application` instead of `run AppName`
