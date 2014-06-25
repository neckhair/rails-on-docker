class BrewWorker
  include Sidekiq::Worker

  def perform(brand_id, count)
    brand = Brand.find brand_id

    started_at = Time.now

    sleep brand.time_to_brew.seconds * count

    brand.reload
    brand.update_attributes in_store: brand.in_store + count
    BrewLog.create brand: brand, count: count, time: (Time.now - started_at)
  end
end
