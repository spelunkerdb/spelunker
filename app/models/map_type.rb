class MapType < ActiveRecord::Base
  include Targeting
  include GameEntry
  include StaticEntry

  has_many    :maps,        Ref::Current,   foreign_key: 'map_type_eid', primary_key: 'eid', inverse_of: :type
end
