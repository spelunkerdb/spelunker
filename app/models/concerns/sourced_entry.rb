module SourcedEntry
  extend ActiveSupport::Concern

  class_methods do
    def target(target)
      # Ensure we're consistently operating on target slugs.
      target = target.slug if target.is_a?(Target)

      target = TargetUtilities.target_for(target, entry_type: :sourced)
      raise 'invalid target' if target.nil?

      RequestStore.store[:spelunker_target] = target

      # Subquery to identify the max-build record id matching the target. Ensures only single
      # entries are returned, even if more than one eid match exists across all appropriately
      # aggregated targets.
      ratcheted_ids = self.
        select("DISTINCT ON (\"#{self.table_name}\".\"eid\") \"#{self.table_name}\".\"id\"").
        in_target_aggregate(target).
        order("\"#{self.table_name}\".\"eid\" ASC, \"#{self.table_name}\".\"build_number\" DESC")

      # Now assemble the full query, ensuring only ratcheted IDs are used.
      self.in_target_aggregate(target).where(id: ratcheted_ids)
    end
  end
end
