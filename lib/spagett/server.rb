require 'sinatra/base'
require 'slack-ruby-client'

module Spagett
  class Server < Sinatra::Base

    def self.run!
      set :threads, ThreadStore.new
      set :users, UserStore.new
      set :client, Slack::RealTime::Client.new(token: ENV["SLACK_TOKEN"])
      set :syosset, Faraday.new(:url => ENV['SYOSSET_HOST'] || 'https://syosseths.com', :params => {:token => ENV['SYOSSET_TOKEN']})

      settings.client.on :hello do
        puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
      end

      settings.client.on :message do |data|
        next unless data.respond_to?(:thread_ts)
        next unless data.channel == ENV["SUPPORT_CHANNEL"]
        next if data.respond_to?(:bot_id) # ignore bot messages

        thread_id = settings.threads.get_thread(data.thread_ts)
        if thread_id.nil?
          puts "No support thread with timestamp #{data.thread_ts} is known, ignoring"
          next
        end

        puts "Updating API with reply to thread #{thread_id} with #{data.text}"
        settings.syosset.post "/threads/#{thread_id}/messages", {user_id: settings.users.get_user(data.user), text: data.text}
      end

      settings.client.start_async

      super
    end

    post '/users/sign_up' do
      settings.users.register_user params[:user_id], params[:text]

      "Your Syosset identity has been linked with Slack. Thanks!"
    end

    post '/threads' do # params: id, user_name
      message = "*#{params[:user_name]}* has opened a support thread."
      notification = settings.client.web_client.chat_postMessage channel: ENV["SUPPORT_CHANNEL"], text: message, as_user: true

      settings.threads.register_thread params[:id], notification.ts

      'ok!'
    end

    post '/threads/:thread/messages' do
      thread_ts = settings.threads.get_thread(params[:thread])
      return 'slack machine broke' if thread_ts.nil?

      settings.client.web_client.chat_postMessage channel: ENV["SUPPORT_CHANNEL"], text: params[:message],
          thread_ts: thread_ts, username: params[:sender][:name], icon_url: params[:sender][:picture]

      'ok!'
    end
  end
end
