class CreatureArea < ActiveRecord::Base
  include Targeting
  include DerivedRecord

  belongs_to  :area,        Ref::Current,     foreign_key: 'area_eid', primary_key: 'eid'
  belongs_to  :creature,    Ref::Aggregated,  foreign_key: 'creature_eid', primary_key: 'eid'

  # Ensure creature area records are established out of creature position data for a given
  # target and creature eid.
  def self.sync!(target, creature_eid)
    target = Target.where(slug: target).first if target.is_a?(String)
    raise ArgumentError.new('missing or invalid target') if !target.is_a?(Target)

    creature = Creature.target(target).at_entry(creature_eid)

    creature.positions.each do |position|
      tile, chunk = CoordinateUtilities.tile_and_chunk_for_coordinate(position.position_x, position.position_y)

      map = Map.target(target).at_entry(position.map_eid)

      next if map.nil?

      map_chunk = map.chunks.where(tile_x: tile.x, tile_y: tile.y, chunk_x: chunk.x, chunk_y: chunk.y).first

      next if map_chunk.nil? || map_chunk.area_eid.nil?

      position_area = Area.target(target).at_entry(map_chunk.area_eid)

      next if position_area.nil?

      creature_area = creature.creature_areas.where(area_eid: position_area.eid, creature_eid: creature.eid).first

      if creature_area.nil?
        creature_area = CreatureArea.new

        creature_area.target = target
        creature_area.creature_eid = creature.eid
        creature_area.area_eid = position_area.eid

        creature_area.save!
      end
    end
  end
end
