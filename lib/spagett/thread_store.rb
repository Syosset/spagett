module Spagett
  class ThreadStore
    def register_thread(thread_id, thread_ts)
      # expire after 32 hours
      $redis.setex "spagett:thread:#{thread_id}", 60*60*32, thread_ts
      $redis.setex "spagett:thread:#{thread_ts}", 60*60*32, thread_id
    end

    def get_thread(query)
      $redis.get "spagett:thread:#{query}"
    end

  end
end
