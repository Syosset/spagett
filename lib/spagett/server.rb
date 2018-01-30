require 'sinatra/base'
require 'slack-ruby-client'
require 'redis'

module Spagett
  class Server < Sinatra::Base

    def self.run!
      set :redis, Redis.new
      set :client, Slack::RealTime::Client.new(token: ENV["SLACK_TOKEN"])

      settings.client.on :hello do
        puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
      end

      settings.client.on :message do |data|
        next unless data.message.try(:thread_ts)
        next unless data.channel == ENV["SUPPORT_CHANNEL"]

        puts "Updating syosseths.com with reply to thread #{data.message.thread_ts} with #{data.message.text}"
      end

      settings.client.start_async

      super
    end

    post '/threads' do # params: id, user_name
      message = "*#{params[:user_name]}* has opened a support thread."
      notification = settings.client.web_client.chat_postMessage channel: ENV["SUPPORT_CHANNEL"], text: message, as_user: true

      thread_id = params[:id]
      settings.redis.set "spagett:thread:#{thread_id}", notification.ts

      'ok!'
    end

    post '/threads/:thread/messages' do
      thread_id = params[:thread]
      thread_notification = settings.redis.get "spagett:thread:#{thread_id}"
      return 'slack machine broke' if thread_notification.nil?

      settings.client.web_client.chat_postMessage channel: ENV["SUPPORT_CHANNEL"], text: params[:message],
          thread_ts: thread_notification, username: params[:sender][:name], icon_url: params[:sender][:picture]

      'ok!'
    end
  end
end
