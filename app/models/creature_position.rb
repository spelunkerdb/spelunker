class CreaturePosition < ActiveRecord::Base
  include Targeting
  include DerivedRecord

  belongs_to  :map,         Ref::Current,     foreign_key: 'area_eid', primary_key: 'eid'
  belongs_to  :creature,    Ref::Aggregated,  foreign_key: 'creature_eid', primary_key: 'eid'
end
