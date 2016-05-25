class BrewJob < ActiveJob::Base
  queue_as :default

  def perform(brand, count)
    started_at = Time.current

    sleep brand.time_to_brew.seconds * count

    brand.reload
    brand.update_attributes in_store: brand.in_store + count
    BrewLog.create brand: brand, count: count, time: (Time.current - started_at)
  end
end
