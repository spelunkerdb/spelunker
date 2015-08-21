class CreaturesController < ApplicationController
  def index
  end

  def show
    @creature = Creature.target(current_target).at_entry(params[:eid])
    raise ActiveRecord::RecordNotFound.new if @creature.nil?
  end
end
