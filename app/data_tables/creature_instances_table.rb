module DataTables
  class CreatureInstancesTable < DataTable
    def root
      Creature.
        target(controller.current_target).
        at_entry(params[:eid]).
        instances
    end

    def columns
      %w(creature_instances.guid creature_instances.level)
    end

    def searchable
      []
    end
  end
end
