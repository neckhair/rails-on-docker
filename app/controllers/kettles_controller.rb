class KettlesController < ApplicationController
  def index
    @workers = Sidekiq::Workers.new
  end
end
