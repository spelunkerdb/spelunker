class MapChunk < ActiveRecord::Base
  belongs_to  :map
  belongs_to  :tile,    class_name: 'MapTile'
end
