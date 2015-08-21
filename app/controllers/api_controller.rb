class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  def api_url(path)
    targeted_url("/api#{path}")
  end
end
