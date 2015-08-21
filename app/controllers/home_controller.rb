class HomeController < ApplicationController
  def index
  end

  def select_target
    session[:target] = Target.where(slug: params[:target]).first.slug

    if params[:p].nil? || params[:p][0, 1] != '/'
      redirect_to('/')
    else
      redirect_to(targeted_url(untargeted_path(params[:p])))
    end
  end
end
