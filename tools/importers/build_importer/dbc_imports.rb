module DBCImports
  def import_dbcs!
    import_map_dbc
    import_area_table_dbc
  end

  private def import_map_dbc
    puts 'Importing Map.dbc ...'

    path = dbc_path_for('Map.dbc')

    dbc = WOW::DBC::Parser.new(path, lazy: true, cache: false)

    Map.transaction do
      loop do
        dbc_record = dbc.next_record
        break if dbc.eof?

        record = Map.target(target).at_entry(dbc_record.id)

        if record.nil?
          record = Map.new
          record.target = target
          record.eid = dbc_record.id
        end

        record.map_type_eid = dbc_record.instance_type
        record.parent_map_eid = dbc_record.parent_map_id
        record.parent_map_eid = nil if record.parent_map_eid < 0
        record.expansion_eid = dbc_record.expansion_id
        record.area_eid = dbc_record.area_table_id
        record.area_eid = nil if record.area_eid <= 0

        record.name = dbc_record.map_name
        record.directory = dbc_record.directory
        record.flags = dbc_record.flags
        record.horde_description = dbc_record.map_description_horde
        record.alliance_description = dbc_record.map_description_alliance
        record.max_players = dbc_record.max_players
        record.max_players = nil if record.max_players <= 0

        record.continent = Map::CONTINENT_EIDS.include?(dbc_record.id)

        record.save!
      end
    end

    dbc.close
  end

  def import_area_table_dbc
    puts 'Importing AreaTable.dbc ...'

    path = dbc_path_for('AreaTable.dbc')

    dbc = WOW::DBC::Parser.new(path, lazy: true, cache: false)

    imported_root_eids = []

    Area.transaction do
      loop do
        dbc_record = dbc.next_record
        break if dbc.eof?

        area = Area.target(target).at_entry(dbc_record.id)

        if area.nil?
          area = Area.new
          area.target = target
          area.eid = dbc_record.id
        end

        area.map_eid = dbc_record.map_id
        area.parent_area_eid = dbc_record.parent_area_id
        area.parent_area_eid = nil if area.parent_area_eid <= 0

        area.name = dbc_record.area_name
        area.internal_name = dbc_record.zone_name

        area.flags_1 = dbc_record.flags_1
        area.flags_2 = dbc_record.flags_2

        area.zone = Zone.target(target).for_area_eid(dbc_record.id).first
        #area.city = City.target(target).for_area_eid(dbc_record.id).first
        #area.dungeon = Dungeon.target(target).for_area_eid(dbc_record.id).first
        #area.raid = Raid.target(target).for_area_eid(dbc_record.id).first
        #area.scenario = Scenario.target(target).for_area_eid(dbc_record.id).first
        #area.battleground = Battleground.target(target).for_area_eid(dbc_record.id).first
        #area.arena = Arena.target(target).for_area_eid(dbc_record.id).first

        area.save!

        imported_root_eids << area.eid if area.root?
      end
    end

    dbc.close

    puts '-> Syncing area trees...'

    Area.transaction do
      imported_root_eids.each do |area_eid|
        Area.sync!(target, area_eid)
      end
    end
  end
end
