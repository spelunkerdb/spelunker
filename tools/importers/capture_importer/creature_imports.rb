module CreatureImports
  private def import_creature_instances
    puts '-> Importing creature instances and positions...'

    @observed_creature_eids = []

    CreatureInstance.transaction do
      @parser.objects.find_by_guid_type(:creature).each do |creature|
        import_creature_instance(creature)
        import_creature_positions(creature)
      end
    end

    @observed_creature_eids.uniq!

    puts '-> Syncing creature stats...'

    CreatureStats.transaction do
      @observed_creature_eids.each do |creature_eid|
        CreatureStats.sync!(@target, creature_eid)
      end
    end

    puts '-> Syncing creature level stats...'

    CreatureLevelStats.transaction do
      @observed_creature_eids.each do |creature_eid|
        CreatureLevelStats.sync!(@target, creature_eid)
      end
    end

    puts '-> Syncing creature areas...'

    CreatureArea.transaction do
      @observed_creature_eids.each do |creature_eid|
        CreatureArea.sync!(@target, creature_eid)
      end
    end
  end

  private def import_creature_positions(creature_object)
    creature = Creature.target(@target).at_entry(creature_object.guid.entry_id)

    # We haven't instantiated a matching creature record yet, so we can't do anything with this
    # instance.
    return if creature.nil?

    creature_object.positions.each do |coordinate|
      position = creature.positions.
        where(map_eid: creature_object.guid.map_id).
        where('round(position_x::numeric, 4) = round((?)::numeric, 4)', coordinate.x).
        where('round(position_y::numeric, 4) = round((?)::numeric, 4)', coordinate.y).
        where('round(position_z::numeric, 4) = round((?)::numeric, 4)', coordinate.z).
        first

      if position.nil?
        position = CreaturePosition.new

        position.target = @target
        position.creature_eid = creature.eid
        position.map_eid = creature_object.guid.map_id
        position.position_x = coordinate.x
        position.position_y = coordinate.y
        position.position_z = coordinate.z

        position.save!
      end
    end
  end

  private def import_creature_instance(creature_object)
    creature = Creature.target(@target).at_entry(creature_object.guid.entry_id)

    # We haven't instantiated a matching creature record yet, so we can't do anything with this
    # instance.
    return if creature.nil?

    instance = creature.instances.where(guid: creature_object.guid.to_i).first

    if instance.nil?
      instance = CreatureInstance.new
      instance.target = @target
      instance.creature_eid = creature_object.guid.entry_id
      instance.guid = creature_object.guid.to_i
      instance.map_eid = creature_object.guid.map_id
    end

    instance.maximum_health = creature_object.attributes.unit_max_health
    instance.maximum_power = creature_object.attributes.unit_max_power
    instance.level = creature_object.attributes.unit_level
    instance.effective_level = creature_object.attributes.unit_effective_level

    instance.gender_eid = (creature_object.attributes.unit_bytes_0 & 0xFF000000) >> 24
    instance.character_class_eid = (creature_object.attributes.unit_bytes_0 & 0x0000FF00) >> 8
    instance.power_type_eid = creature_object.attributes.unit_display_power
    instance.power_type_eid = nil if instance.power_type_eid == -1
    instance.faction_eid = creature_object.attributes.unit_faction_template

    instance.base_attack_time = creature_object.attributes.unit_base_attack_time
    instance.ranged_attack_time = creature_object.attributes.unit_base_attack_time_2

    instance.save!

    # Update a few attributes on base creature record. Presumption: that character class, power
    # type, and faction don't vary with instances.
    creature.character_class_eid = instance.character_class_eid
    creature.power_type_eid = instance.power_type_eid
    creature.faction_eid = instance.faction_eid
    creature.save!

    # Store for later sync operations.
    @observed_creature_eids << creature_object.guid.entry_id
  end

  private def import_from_creature_query(packet)
    return if !packet.has_data?

    creature = Creature.target(@target).at_entry(packet.entry_id)

    if creature.nil?
      creature = Creature.new
      creature.target = @target
      creature.eid = packet.entry_id
      creature.build_number = @target.level.build.number
    end

    creature.expansion_eid = packet.expansion.index
    creature.creature_movement_info_eid = packet.creature_movement_info_id
    creature.creature_family_eid = packet.creature_family_id
    creature.creature_type_eid = packet.creature_type_id
    creature.creature_rank_eid = packet.creature_rank.index

    creature.name = packet.name
    creature.female_name = packet.female_name
    creature.title = packet.title
    creature.female_title = packet.female_title
    creature.cursor_name = packet.cursor_name
    creature.health_multiplier = packet.health_multiplier
    creature.power_multiplier = packet.power_multiplier
    creature.racial_leader = packet.racial_leader?
    creature.flags_1 = packet.flags_1
    creature.flags_2 = packet.flags_2
    creature.quest_flags = packet.quest_flags

    creature.save!

    # Add quest items (unless already added).
    packet.quest_item_ids.each_with_index do |item_id, index|
      next if item_id == 0
      next if creature.has_quest_item?(item_id)

      cqib = CreatureQuestItemBinding.new
      cqib.creature = creature
      cqib.item_eid = item_id
      cqib.index = index
      cqib.save!
    end

    # Add creature displays (unless already added).
    packet.creature_display_ids.each_with_index do |creature_display_id, index|
      next if creature_display_id == 0
      next if creature.has_display?(creature_display_id)

      cdb = CreatureDisplayBinding.new
      cdb.creature = creature
      cdb.creature_display_eid = creature_display_id
      cdb.index = index
      cdb.save!
    end

    # Add creature kill credits (unless already added).
    packet.creature_kill_credit_ids.each_with_index do |creature_kill_credit_id, index|
      next if creature_kill_credit_id == 0
      next if creature.has_kill_credit?(creature_kill_credit_id)

      ckcb = CreatureKillCreditBinding.new
      ckcb.creature = creature
      ckcb.kill_credit_eid = creature_kill_credit_id
      ckcb.index = index
      ckcb.save!
    end
  end
end
