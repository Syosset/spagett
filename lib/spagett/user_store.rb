module Spagett
  class UserStore
    def register_user(slack_id, syosset_id)
      $redis.set "spagett:user:#{slack_id}", syosset_id
    end

    def get_user(slack_id)
      $redis.get "spagett:user:#{slack_id}"
    end
  end
end
