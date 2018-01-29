require 'sinatra/base'
require 'slack-ruby-client'
require 'pry'

module Spagett
  class Server < Sinatra::Base

    def self.run!
      set :client, Slack::RealTime::Client.new(token: ENV["SLACK_TOKEN"])

      settings.client.on :hello do
        puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
      end

      settings.client.start_async

      super
    end

    post '/thread' do # params: id, user
      puts settings.client.web_client.chat_postMessage channel: "#support", text: "Hi!"
    end
  end
end
