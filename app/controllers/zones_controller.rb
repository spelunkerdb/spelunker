class ZonesController < ApplicationController
  def index
  end

  def show
    @zone = Zone.target(current_target).at_slug(params[:slug])
  end
end
