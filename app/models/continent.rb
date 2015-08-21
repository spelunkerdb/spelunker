class Continent < ActiveRecord::Base
  include Targeting
  include StaticSeed

  has_many    :zones
end
