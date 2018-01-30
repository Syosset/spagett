require "spagett/version"
require 'dotenv/load'
require "spagett/thread_store"
require "spagett/server"

module Spagett
  Server.run!
end
