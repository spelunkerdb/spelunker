class CreatureStats < ActiveRecord::Base
  include Targeting

  # Based on creature instances targeted at relevant targeting levels, calculate stats and create
  # or update stats record. Typically called after a capture import runs.
  def self.sync!(root_target, creature_eid)
    root_target = Target.where(slug: root_target).first if root_target.is_a?(String)
    raise ArgumentError.new('missing or invalid root target') if !root_target.is_a?(Target)

    target_tree = root_target.target_tree

    CreatureStats.transaction do
      target_tree.each do |target|
        creature = Creature.target(target).at_entry(creature_eid)
        raise 'missing creature eid' if creature.nil?

        creature_instances = creature.instances
        next if creature_instances.count == 0

        minimum_level = creature_instances.minimum(:level)
        maximum_level = creature_instances.maximum(:level)
        average_level = creature_instances.average(:level)

        minimum_health = creature_instances.minimum(:maximum_health)
        maximum_health = creature_instances.maximum(:maximum_health)
        average_health = creature_instances.average(:maximum_health)

        minimum_power = creature_instances.minimum(:maximum_power)
        maximum_power = creature_instances.maximum(:maximum_power)
        average_power = creature_instances.average(:maximum_power)

        creature_stats = creature.stats

        if creature_stats.nil?
          creature_stats = CreatureStats.new
          creature_stats.target = target
          creature_stats.creature_eid = creature_eid
        end

        creature_stats.minimum_level = minimum_level
        creature_stats.maximum_level = maximum_level
        creature_stats.average_level = average_level

        creature_stats.minimum_health = minimum_health
        creature_stats.maximum_health = maximum_health
        creature_stats.average_health = average_health

        creature_stats.minimum_power = minimum_power
        creature_stats.maximum_power = maximum_power
        creature_stats.average_power = average_power

        creature_stats.save!
      end
    end
  end
end
