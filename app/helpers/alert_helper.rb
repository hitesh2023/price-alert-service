module AlertHelper
  include RedisHelper
  
  def store_alert_in_redis(coin_id, price, alert_id)
    redis_key = get_sorted_set_key_via_coin_id(coin_id)
    REDIS.zadd(redis_key, price, alert_id)
  end

  def remove_alert_from_redis(coin_id, alert_id)
    redis_key = get_sorted_set_key_via_coin_id(coin_id)
    REDIS.zrem(redis_key, alert_id)
  end
end