module DataTables
  class ZoneCreaturesTable < DataTable
    def root
      Zone.
        target(controller.current_target).
        at_slug(params[:slug]).
        creatures
    end

    def columns
      %w(creatures.name creatures.name)
    end

    def searchable
      %w(creatures.name)
    end
  end
end
