class BrewLogsController < ApplicationController

  def index
    @brew_logs = BrewLog.order('created_at DESC').limit(50)
  end

end
