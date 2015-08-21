module CoordinateUtilities
  MAP_SIZE = 34133.333
  TILE_SIZE = 34133.333 / 64.0
  CHUNK_SIZE = 34133.333 / 64.0 / 16.0

  Tile = Struct.new(:x, :y)
  Chunk = Struct.new(:x, :y)

  # Given a coordinate in World of Warcraft's standard coordinate system, identify the map tile and
  # chunk corresponding to the coordinate. Note that X and Y are inverted for whatever reason.
  def self.tile_and_chunk_for_coordinate(x, y)
    normalized_x = (y - (MAP_SIZE / 2.0)).abs
    normalized_y = (x - (MAP_SIZE / 2.0)).abs

    tile_x = (normalized_x / TILE_SIZE).floor
    tile_y = (normalized_y / TILE_SIZE).floor

    offset_x = normalized_x - (tile_x * TILE_SIZE)
    offset_y = normalized_y - (tile_y * TILE_SIZE)

    chunk_x = (offset_x / CHUNK_SIZE).floor
    chunk_y = (offset_y / CHUNK_SIZE).floor

    tile = Tile.new(tile_x, tile_y)
    chunk = Chunk.new(chunk_x, chunk_y)

    [tile, chunk]
  end
end
