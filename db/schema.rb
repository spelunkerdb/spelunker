# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150821011312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",                 null: false
    t.integer "zone_id"
    t.integer "eid",                       null: false
    t.integer "map_eid"
    t.integer "parent_area_eid"
    t.string  "name"
    t.string  "internal_name"
    t.integer "flags_1",         limit: 8
    t.integer "flags_2",         limit: 8
  end

  add_index "areas", ["target_id", "eid"], name: "idx_areas_uniq", unique: true, using: :btree

  create_table "captures", id: :bigserial, force: :cascade do |t|
    t.integer  "target_id",     null: false
    t.integer  "packets_count"
    t.string   "file_hash",     null: false
    t.integer  "file_size",     null: false
    t.string   "file_name",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "captures", ["file_hash"], name: "index_captures_on_file_hash", unique: true, using: :btree

  create_table "client_builds", id: :bigserial, force: :cascade do |t|
    t.integer "client_era_id",     null: false
    t.integer "client_version_id", null: false
    t.integer "client_patch_id",   null: false
    t.string  "slug",              null: false
    t.integer "number",            null: false
    t.string  "archive_type",      null: false
    t.date    "released_on",       null: false
    t.boolean "supported",         null: false
  end

  create_table "client_eras", id: :bigserial, force: :cascade do |t|
    t.string  "name",             null: false
    t.string  "subdomain",        null: false
    t.string  "slug",             null: false
    t.integer "current_build_id"
  end

  create_table "client_patches", id: :bigserial, force: :cascade do |t|
    t.integer "client_era_id",     null: false
    t.integer "client_version_id", null: false
    t.string  "slug",              null: false
    t.integer "current_build_id"
  end

  create_table "client_versions", id: :bigserial, force: :cascade do |t|
    t.integer "client_era_id",    null: false
    t.string  "slug",             null: false
    t.integer "current_build_id"
  end

  create_table "continents", id: :bigserial, force: :cascade do |t|
    t.integer "target_id", null: false
    t.string  "name",      null: false
    t.string  "slug",      null: false
  end

  create_table "creature_areas", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",    null: false
    t.integer "creature_eid", null: false
    t.integer "area_eid",     null: false
  end

  add_index "creature_areas", ["target_id", "creature_eid", "area_eid"], name: "idx_creature_areas_uniq", unique: true, using: :btree

  create_table "creature_display_bindings", id: :bigserial, force: :cascade do |t|
    t.integer "creature_id",          null: false
    t.integer "creature_display_eid", null: false
    t.integer "index",                null: false
  end

  create_table "creature_instances", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",                          null: false
    t.integer "creature_eid",                       null: false
    t.decimal "guid",                precision: 39, null: false
    t.integer "map_eid",                            null: false
    t.integer "character_class_eid"
    t.integer "gender_eid"
    t.integer "faction_eid"
    t.integer "power_type_eid"
    t.integer "level"
    t.integer "effective_level"
    t.integer "maximum_health"
    t.integer "maximum_power"
    t.integer "base_attack_time"
    t.integer "ranged_attack_time"
  end

  add_index "creature_instances", ["guid"], name: "idx_creature_instances_uniq", unique: true, using: :btree

  create_table "creature_kill_credit_bindings", id: :bigserial, force: :cascade do |t|
    t.integer "creature_id",     null: false
    t.integer "kill_credit_eid", null: false
    t.integer "index",           null: false
  end

  create_table "creature_level_stats", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",      null: false
    t.integer "creature_eid",   null: false
    t.integer "level",          null: false
    t.integer "minimum_health"
    t.integer "maximum_health"
    t.integer "average_health"
    t.integer "minimum_power"
    t.integer "maximum_power"
    t.integer "average_power"
  end

  add_index "creature_level_stats", ["target_id", "creature_eid", "level"], name: "idx_creature_level_stats_uniq", unique: true, using: :btree

  create_table "creature_positions", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",    null: false
    t.integer "creature_eid", null: false
    t.integer "map_eid",      null: false
    t.float   "position_x",   null: false
    t.float   "position_y",   null: false
    t.float   "position_z",   null: false
  end

  create_table "creature_quest_item_bindings", id: :bigserial, force: :cascade do |t|
    t.integer "creature_id", null: false
    t.integer "item_eid",    null: false
    t.integer "index",       null: false
  end

  create_table "creature_stats", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",      null: false
    t.integer "creature_eid",   null: false
    t.integer "minimum_level"
    t.integer "maximum_level"
    t.integer "average_level"
    t.integer "minimum_health"
    t.integer "maximum_health"
    t.integer "average_health"
    t.integer "minimum_power"
    t.integer "maximum_power"
    t.integer "average_power"
  end

  add_index "creature_stats", ["target_id", "creature_eid"], name: "idx_creature_stats_uniq", unique: true, using: :btree

  create_table "creatures", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",                            null: false
    t.integer "build_number",                         null: false
    t.integer "eid",                                  null: false
    t.integer "character_class_eid"
    t.integer "faction_eid"
    t.integer "power_type_eid"
    t.integer "expansion_eid"
    t.integer "creature_movement_info_eid"
    t.integer "creature_family_eid"
    t.integer "creature_type_eid"
    t.integer "creature_rank_eid"
    t.string  "name"
    t.string  "female_name"
    t.string  "title"
    t.string  "female_title"
    t.string  "cursor_name"
    t.float   "health_multiplier"
    t.float   "power_multiplier"
    t.boolean "racial_leader"
    t.integer "flags_1",                    limit: 8
    t.integer "flags_2",                    limit: 8
    t.integer "quest_flags",                limit: 8
  end

  add_index "creatures", ["target_id", "eid"], name: "idx_creatures_uniq", unique: true, using: :btree

  create_table "map_chunks", id: :bigserial, force: :cascade do |t|
    t.integer "map_id",                null: false
    t.integer "map_tile_id",           null: false
    t.integer "area_eid"
    t.integer "tile_x",                null: false
    t.integer "tile_y",                null: false
    t.integer "chunk_x",               null: false
    t.integer "chunk_y",               null: false
    t.integer "flags",       limit: 8
    t.float   "position_x"
    t.float   "position_y"
    t.float   "position_z"
  end

  create_table "map_tiles", id: :bigserial, force: :cascade do |t|
    t.integer "map_id",                        null: false
    t.integer "tile_x",                        null: false
    t.integer "tile_y",                        null: false
    t.boolean "extant",        default: false, null: false
    t.string  "adt_file_hash"
  end

  create_table "map_types", id: :bigserial, force: :cascade do |t|
    t.integer "target_id", null: false
    t.integer "eid",       null: false
    t.string  "value",     null: false
    t.string  "slug",      null: false
    t.string  "label",     null: false
  end

  add_index "map_types", ["target_id", "eid"], name: "idx_map_types_uniq", unique: true, using: :btree

  create_table "maps", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",                                      null: false
    t.integer "eid",                                            null: false
    t.integer "map_type_eid"
    t.integer "area_eid"
    t.integer "parent_map_eid"
    t.integer "expansion_eid"
    t.string  "name"
    t.string  "directory"
    t.integer "flags",                limit: 8
    t.string  "horde_description"
    t.string  "alliance_description"
    t.integer "max_players"
    t.boolean "tiled",                          default: false, null: false
    t.boolean "continent",                      default: false, null: false
  end

  add_index "maps", ["target_id", "eid"], name: "idx_maps_uniq", unique: true, using: :btree

  create_table "target_aggregates", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",            null: false
    t.integer "aggregated_target_id", null: false
  end

  create_table "targets", id: :bigserial, force: :cascade do |t|
    t.string  "slug",              null: false
    t.string  "level",             null: false
    t.integer "current_target_id"
  end

  add_index "targets", ["slug"], name: "idx_targets_uniq", unique: true, using: :btree

  create_table "territory_factions", id: :bigserial, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
  end

  create_table "zones", id: :bigserial, force: :cascade do |t|
    t.integer "target_id",                            null: false
    t.integer "continent_id",                         null: false
    t.integer "territory_faction_id"
    t.string  "name",                                 null: false
    t.string  "slug",                                 null: false
    t.integer "suggested_minimum_level"
    t.integer "suggested_maximum_level"
    t.integer "map_eid"
    t.jsonb   "area_eids",               default: [], null: false
  end

end
