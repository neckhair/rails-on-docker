class BrewWorker
  include Sidekiq::Worker

  def perform(brand_id, count)
    brand = Brand.find brand_id

    started_at = Time.now

    count.times do |n|
      brand.update_attributes in_store: brand.in_store + 1
      sleep brand.time_to_brew.seconds
    end

    BrewLog.create brand: brand, count: count, time: (Time.now - started_at)
  end
end
