require 'net/http'
class FetchLatestCrptoPricesJob < ApplicationJob
  include RedisHelper
  include AlertHelper
  queue_as :default

  def perform(*args)
    uri = URI('https://api.coingecko.com/api/v3/coins/markets')
    params = {
      :per_page => 100,
      :page => 1,
      :sparkline => false,
      :vs_currency => 'USD',
      :order => 'market_cap_desc'
    }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      records = JSON.parse(res.body)
      records.each do |record|
        trigger_alert_to_users_subscribed_to_current_record(record.with_indifferent_access)
      end
    end
  end

  def trigger_alert_to_users_subscribed_to_current_record(record)
    coin_id = record[:symbol].upcase
    redis_key = get_sorted_set_key_via_coin_id(coin_id)
    alert_ids = REDIS.zrangebyscore(redis_key, record[:current_price], "+inf", :with_scores => true)

    alert_ids.each do |alert|
      alert_id, score = alert[0].to_i, alert[1].to_f
      alert = Alert.find(alert_id)
      if ['CREATED', 'FAILED'].include?(alert.status)
        print("***Sending email alert to user: #{alert.user.email}, current_price: #{record[:current_price]}, stop_loss_price: #{score}***\n")
        alert.status = Alert.statuses['TRIGGERED']
        remove_alert_from_redis(coin_id, alert_id)
      else
        print("***Failed to send email to user: current_status: #{alert.status}, current_price: #{record[:current_price]}, stop_loss_price: #{score}***\n")
        alert.status = Alert.statuses['FAILED']
      end
      alert.save!
    end
  end
end
# FetchLatestCrptoPricesJob.new.perform