require 'spagett/version'
require 'dotenv/load'
require 'spagett/thread_store'
require 'spagett/user_store'
require 'spagett/server'
require 'redis'

module Spagett
  redis = Redis.new(url: ENV["REDIS_URL"])

  threads = ThreadStore.new(redis)
  users = UserStore.new(redis)

  Server.run(threads, users)
end
