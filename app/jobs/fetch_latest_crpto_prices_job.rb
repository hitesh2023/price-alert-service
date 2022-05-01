class FetchLatestCrptoPricesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    print("hello this is executed")
  end
end
