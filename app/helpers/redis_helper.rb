module RedisHelper
  def get_sorted_set_key_via_coin_id(coin_id)
    return "SORTED_SET::COIN_ID::#{coin_id.upcase}"
  end
end