module DataTables
  class CreatureLevelStatsTable < DataTable
    def root
      Creature.
        target(controller.current_target).
        at_entry(params[:eid]).
        level_stats
    end

    def columns
      %w(creature_level_stats.level creature_level_stats.minimum_health creature_level_stats.average_health creature_level_stats.minimum_power creature_level_stats.average_power)
    end

    def searchable
      []
    end
  end
end
