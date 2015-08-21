module GameEntry
  extend ActiveSupport::Concern

  class_methods do
    def at_entry(entry_id)
      where(eid: entry_id.to_i).first
    end

    def has_entry?(entry_id)
      !at_entry(entry_id).nil?
    end
  end
end
