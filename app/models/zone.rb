class Zone < ActiveRecord::Base
  include Targeting
  include StaticSeed

  belongs_to  :continent
  belongs_to  :territory_faction

  has_many    :areas,               Ref::Current
  has_many    :creatures,           Ref::Aggregated,  through: :areas

  def self.for_area_eid(eid)
    where('"zones"."area_eids" @> ?', eid.to_s)
  end

  def dom_id
    "zone-#{self.id}"
  end

  def url
    "/zones/#{self.slug}"
  end
end
