module Spagett
  class UserStore
    def register_user(slack_id, syosset_id)
      $redis.set "spagett:user:#{slack_id}", syosset_id
      $redis.set "spagett:user:#{syosset_id}", slack_id
    end

    def get_user(query)
      $redis.get "spagett:user:#{query}"
    end
  end
end
