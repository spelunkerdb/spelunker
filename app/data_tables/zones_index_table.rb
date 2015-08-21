module DataTables
  class ZonesIndexTable < DataTable
    def root
      Zone.
        target(controller.current_target).
        includes(:territory_faction, :continent).
        references(:territory_faction, :continent)
    end

    def columns
      %w(zones.name zones.suggested_minimum_level continents.name territory_factions.name)
    end

    def searchable
      %w(zones.name continents.name)
    end
  end
end
