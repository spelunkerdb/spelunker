class Map < ActiveRecord::Base
  include Targeting
  include GameEntry
  include StaticEntry

  CONTINENT_EIDS = [0, 1, 530, 571, 870, 1116]

  belongs_to  :type,        Ref::Current,   class_name: 'MapType', foreign_key: 'map_type_eid', primary_key: 'eid', inverse_of: :maps
  belongs_to  :parent_map,  Ref::Current,   class_name: 'Map', foreign_key: 'parent_map_eid', primary_key: 'eid'
  belongs_to  :area,        Ref::Current,   class_name: 'Area', foreign_key: 'area_eid', primary_key: 'eid'

  has_many    :tiles,                       class_name: 'MapTile'
  has_many    :chunks,                      class_name: 'MapChunk'

  def dom_id
    "map-#{self.id}"
  end

  def url
    "/maps/#{self.eid}"
  end

  def tiles_loaded?
    self.tiles.count == 64 * 64
  end

  def chunks_loaded?
    self.chunks.count == self.tiles.extant.count * 16 * 16
  end
end
