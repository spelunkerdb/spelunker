module DataTables
  class CreaturesIndexTable < DataTable
    def root
      Creature.
        target(controller.current_target)
    end

    def columns
      %w(creatures.name)
    end

    def searchable
      %w(creatures.name)
    end
  end
end
