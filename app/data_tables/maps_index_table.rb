module DataTables
  class MapsIndexTable < DataTable
    def root
      Map.
        target(controller.current_target).
        includes(:type).
        references(:type)
    end

    def columns
      %w(maps.eid map_types.label maps.name)
    end

    def searchable
      %w(map_types.label maps.name)
    end
  end
end
