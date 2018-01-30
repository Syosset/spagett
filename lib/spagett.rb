require "spagett/version"
require 'dotenv/load'
require "spagett/thread_store"
require "spagett/user_store"
require "spagett/server"
require 'redis'

module Spagett
  $redis = Redis.new
  Server.run!
end
