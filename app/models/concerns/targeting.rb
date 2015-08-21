module Targeting
  extend ActiveSupport::Concern

  module Ref
    # For the selected target, pull associated records attached to the most-current target related
    # to the selected target. For example: in a creature spell derived record, the reference to the
    # spell entry would likely be a Ref::Current association.
    #
    # Effectively, Ref::Current is useful for associations referencing static data that's fully
    # extant for a given build-- primarily, this is data loaded from dbc and db2 files.
    Current = lambda do
      target = RequestStore.store[:spelunker_target]

      joins(:target).
        joins('INNER JOIN "target_aggregates" ON "target_aggregates"."aggregated_target_id" = "targets"."id"').
        where("\"#{self.table_name}\".\"target_id\" = #{target.current_target_id}").
        distinct
    end

    # For the selected target, pull associated records attached to the selected target. Primarily
    # used for per-level summary records, such as CreatureStats records.
    Locked = lambda do
      target = RequestStore.store[:spelunker_target]

      joins(:target).
        joins('INNER JOIN "target_aggregates" ON "target_aggregates"."target_id" = "targets"."id"').
        where("\"#{self.table_name}\".\"target_id\" = #{target.id}").
        distinct
    end

    # For the selected target, given the targets affiliated with the selected target, pull all
    # records matching any of the affiliated targets. For example: target 6.2.x refers to a
    # version target. That version target aggregates all client builds released during the 6.2.x
    # era of the game.
    #
    # Primarily used for derived data, such as CreatureArea and CreatureSpell records.
    Aggregated = lambda do
      target = RequestStore.store[:spelunker_target]

      joins(:target).
        joins('INNER JOIN "target_aggregates" ON "target_aggregates"."aggregated_target_id" = "targets"."id"').
        where("\"target_aggregates\".\"target_id\" = ?", target.id)
    end
  end

  included do
    belongs_to :target

    def build
      self.target.fetch_level.current_build
    end
  end

  class_methods do
    def in_target(target)
      joins(:target).where("\"targets\".\"id\" = ?", target.id)
    end

    def in_target_aggregate(target)
      joins(:target).
      joins('INNER JOIN "target_aggregates" ON "target_aggregates"."aggregated_target_id" = "targets"."id"').
      where("\"target_aggregates\".\"target_id\" = ?", target.id)
    end
  end
end
