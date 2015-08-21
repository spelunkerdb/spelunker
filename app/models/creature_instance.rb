class CreatureInstance < ActiveRecord::Base
  include Targeting

  def self.level(level)
    self.where(level: level)
  end
end
