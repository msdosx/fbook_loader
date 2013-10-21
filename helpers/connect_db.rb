require 'sinatra/base'
require 'sinatra/activerecord'
require 'active_record'
require 'yaml'

class Connect_db < Sinatra::Base
    dbconfig = YAML::load(File.open('./config/database.yml'))
    ActiveRecord::Base.establish_connection(dbconfig)

  # start the server if ruby file executed directly
  run! if Connect_db == $0
end
