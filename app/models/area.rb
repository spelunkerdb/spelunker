class Area < ActiveRecord::Base
  include Targeting
  include GameEntry
  include StaticEntry

  belongs_to  :zone
  belongs_to  :city
  belongs_to  :dungeon
  belongs_to  :raid
  belongs_to  :scenario
  belongs_to  :battleground
  belongs_to  :arena

  belongs_to  :map,             Ref::Current,     class_name: 'Map', foreign_key: 'map_eid', primary_key: 'eid'
  belongs_to  :parent_area,     Ref::Current,     class_name: 'Area', foreign_key: 'parent_area_eid', primary_key: 'eid'

  has_many    :creature_areas,  Ref::Current,     foreign_key: 'area_eid', primary_key: 'eid'
  has_many    :creatures,       Ref::Aggregated,  through: :creature_areas, source: 'creature'

  def self.top_level
    where(parent_area_eid: nil)
  end

  def dom_id
    "area-#{self.id}"
  end

  def url
    "/areas/#{self.eid}"
  end

  def root?
    self.parent_area_eid.nil? || self.parent_area_eid == 0
  end

  def leaf?
    !Area.where(parent_area_eid: self.eid).exists?
  end

  # Recurse and flatten the children of this area.
  def children
    leaf? ? [self] : Area.where(parent_area_eid: self.eid).map(&:children).flatten
  end

  # Ensures all children of area via tree traversal are hooked to the same root-level information,
  # such as zone, dungeon, city, etc.
  def self.sync!(target, area_eid)
    target = Target.where(slug: target).first if target.is_a?(String)
    raise ArgumentError.new('missing or invalid target') if !target.is_a?(Target)

    root_area = Area.target(target).at_entry(area_eid)

    root_area.children.each do |child_area|
      child_area.zone = root_area.zone
      #child_area.city = root_area.city
      #child_area.dungeon = root_area.dungeon
      #child_area.raid = root_area.raid
      #child_area.scenario = root_area.scenario
      #child_area.battleground = root_area.battleground
      #child_area.arena = root_area.arena

      child_area.save!
    end
  end
end
