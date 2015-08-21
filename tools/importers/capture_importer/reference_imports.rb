private def import_reference(reference)
  case reference.entry_type
  when :creature
    Creature.transaction do
      import_creature_reference(reference)
    end
  when :item
    Item.transaction do
      import_item_reference(reference)
    end
  end
end

private def import_creature_reference(reference)
  creature = Creature.in_build(@build).at_entry(reference.entry_id)
  return if creature.nil?

  existing_reference = creature.references.
    in_capture(@capture).
    at_packet_index(reference.packet_index).
    with_type(reference.reference_type).
    first

  return if !existing_reference.nil?

  reference_record = creature.references.new
  reference_record.capture = @capture
  reference_record.packet = @capture.packets.at_index(reference.packet_index)
  reference_record.reference_type = reference.reference_type
  reference_record.reference_label = reference.reference_label

  reference_record.save!
end

private def import_item_reference(reference)
end
