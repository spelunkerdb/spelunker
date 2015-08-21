module StaticEntry
  extend ActiveSupport::Concern

  class_methods do
    def target(target)
      # Ensure we're consistently operating on target slugs.
      target = target.slug if target.is_a?(Target)

      target = TargetUtilities.target_for(target, entry_type: :static)
      raise 'invalid target' if target.nil?

      RequestStore.store[:spelunker_target] = target

      self.in_target(target)
    end
  end
end
