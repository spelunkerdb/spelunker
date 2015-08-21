class MapTile < ActiveRecord::Base
  belongs_to  :map

  has_many    :chunks, class_name: 'MapChunk'

  def self.extant
    self.where(extant: true)
  end

  def chunks_loaded?
    self.chunks.count == 16 * 16
  end
end
