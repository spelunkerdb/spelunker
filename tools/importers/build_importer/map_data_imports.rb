module MapDataImports
  def import_map_data!
    import_map_tiles
    import_map_chunks
  end

  # Map Tiles
  def import_map_tiles
    puts 'Importing map tiles...'

    puts '-> Identifying tiled maps...'

    tiled_maps = []

    Map.target(target).each do |map|
      map_directory_path = map_path_for(map.directory)

      adt_files = Dir.glob("#{map_directory_path}/*.adt")

      tiled_files = adt_files.select { |path| /[\d][\d]_[\d][\d]/ =~ path }

      if tiled_files.length > 0
        if !map.tiled?
          map.tiled = true
          map.save!
        end

        tiled_maps << map

        puts "-> Identified tiled map: #{map.name} (#{map.directory})"
      end
    end

    puts '-> Building tiles...'

    tiled_maps.each do |map|
      next if map.tiles_loaded?

      MapTile.transaction do
        (0...64).each do |tile_y|
          (0...64).each do |tile_x|
            tile_adt_path = "#{map_path_for(map.directory)}/#{map.directory}_#{tile_x}_#{tile_y}.adt"

            tile = map.tiles.new
            tile.tile_x = tile_x
            tile.tile_y = tile_y
            tile.extant = File.exist?(tile_adt_path)
            tile.adt_file_hash = file_hash(tile_adt_path) if tile.extant?

            tile.save!
          end
        end
      end

      puts "-> Created #{map.tiles.count} tiles for #{map.name} (#{map.directory})"
    end
  end

  # MCNK records in ADT files for maps -- provide link between positions and area entry IDs.
  def import_map_chunks
    puts 'Importing map chunks...'

    puts "-> Identifying tiled maps..."

    tiled_maps = Map.target(target).where(tiled: true).all

    tiled_maps.each do |map|
      next if map.chunks_loaded?

      puts "-> Seeding chunks for map: #{map.name} (#{map.directory})"

      map.tiles.extant.each do |tile|
        next if tile.chunks_loaded?

        tile_adt_path = "#{map_path_for(map.directory)}/#{map.directory}_#{tile.tile_x}_#{tile.tile_y}.adt"
        tile_adt_hash = file_hash(tile_adt_path)

        seed_map_tile_adt(map, tile, tile_adt_path)

        GC.start
      end
    end
  end

  def seed_map_tile_adt(map, tile, tile_adt_path)
    puts "-> Seeding chunks for tile: #{map.directory}_#{tile.tile_x}_#{tile.tile_y}"

    tile_adt = WOW::ADT::Parser.new(tile_adt_path, lazy: true, cache: false)

    Map.transaction do
      while !tile_adt.eof?
        record = tile_adt.next_record
        next if record.type != :MCNK

        chunk = tile.chunks.new

        chunk.map = map
        chunk.area_eid = record.header[:area_id]
        chunk.area_eid = nil if chunk.area_eid <= 0
        chunk.tile_x = tile.tile_x
        chunk.tile_y = tile.tile_y
        chunk.chunk_x = record.header[:index_x]
        chunk.chunk_y = record.header[:index_y]
        chunk.flags = record.header[:flags]
        chunk.position_x = record.header[:position_x]
        chunk.position_y = record.header[:position_y]
        chunk.position_z = record.header[:position_z]

        chunk.save!
      end
    end

    tile_adt.close
  end
end
