class CreatureLevelStats < ActiveRecord::Base
  include Targeting

  def self.at_level(level)
    self.where(level: level).first
  end

  # Based on creature instances targeted at relevant targeting levels, calculate
  # creature-level-specific stats and create or update level stats records. Typically called after
  # a capture import runs.
  def self.sync!(root_target, creature_eid)
    root_target = Target.where(slug: root_target).first if root_target.is_a?(String)
    raise ArgumentError.new('missing or invalid root target') if !root_target.is_a?(Target)

    target_tree = root_target.target_tree

    CreatureLevelStats.transaction do
      target_tree.each do |target|
        creature = Creature.target(target).at_entry(creature_eid)
        raise 'missing creature eid' if creature.nil?

        creature_instances = creature.instances
        next if creature_instances.count == 0

        creature_levels = creature_instances.pluck(:level)

        creature_levels.each do |creature_level|
          level_instances = creature.instances.level(creature_level)

          minimum_health = level_instances.minimum(:maximum_health)
          maximum_health = level_instances.maximum(:maximum_health)
          average_health = level_instances.average(:maximum_health)

          minimum_power = level_instances.minimum(:maximum_power)
          maximum_power = level_instances.maximum(:maximum_power)
          average_power = level_instances.average(:maximum_power)

          level_stats = creature.level_stats.at_level(creature_level)

          if level_stats.nil?
            level_stats = CreatureLevelStats.new
            level_stats.target = target
            level_stats.creature_eid = creature_eid
            level_stats.level = creature_level
          end

          level_stats.minimum_health = minimum_health
          level_stats.maximum_health = maximum_health
          level_stats.average_health = average_health

          level_stats.minimum_power = minimum_power
          level_stats.maximum_power = maximum_power
          level_stats.average_power = average_power

          level_stats.save!
        end
      end
    end
  end
end
