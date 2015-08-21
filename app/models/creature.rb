class Creature < ActiveRecord::Base
  include Targeting
  include GameEntry
  include SourcedEntry

  has_many  :positions,             Ref::Aggregated,  class_name: 'CreaturePosition', foreign_key: 'creature_eid', primary_key: 'eid'
  has_many  :creature_areas,        Ref::Aggregated,  foreign_key: 'creature_eid', primary_key: 'eid'
  has_many  :areas,                 Ref::Current,     through: :creature_areas, source: 'area'
  has_many  :instances,             Ref::Aggregated,  class_name: 'CreatureInstance', foreign_key: 'creature_eid', primary_key: 'eid'
  has_one   :stats,                 Ref::Locked,      class_name: 'CreatureStats', foreign_key: 'creature_eid', primary_key: 'eid'
  has_many  :level_stats,           Ref::Locked,      class_name: 'CreatureLevelStats', foreign_key: 'creature_eid', primary_key: 'eid'
  has_many  :display_bindings,                        class_name: 'CreatureDisplayBinding'
  has_many  :quest_item_bindings,                     class_name: 'CreatureQuestItemBinding'
  has_many  :kill_credit_bindings,                    class_name: 'CreatureKillCreditBinding'

  def dom_id
    "creature-#{self.id}"
  end

  def url
    "/creatures/#{self.eid}"
  end

  def has_display?(eid)
    display_bindings.where(creature_display_eid: eid).exists?
  end

  def has_kill_credit?(eid)
    kill_credit_bindings.where(kill_credit_eid: eid).exists?
  end

  def has_quest_item?(eid)
    quest_item_bindings.where(item_eid: eid).exists?
  end
end
