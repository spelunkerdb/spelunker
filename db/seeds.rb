require 'json'

def relative_path(path)
  File.expand_path("../#{path}", __FILE__)
end

def read_json(path)
  file = File.open(path, 'rb')
  contents = file.read
  file.close

  JSON.parse(contents)
end

def seed_eras
  puts 'Seeding eras...'

  raw_eras = read_json(relative_path('seeds/client_eras.json'))

  ClientEra.transaction do
    raw_eras.each do |raw_era|
      era = ClientEra.where(slug: raw_era['slug']).first

      if era.nil?
        era = ClientEra.new
        era.slug = raw_era['slug']
      end

      era.name = raw_era['name']
      era.subdomain = raw_era['subdomain']

      era.save!
    end
  end
end

def seed_versions
  puts 'Seeding versions...'

  raw_versions = read_json(relative_path('seeds/client_versions.json'))

  ClientVersion.transaction do
    raw_versions.each do |raw_version|
      version = ClientVersion.where(slug: raw_version['slug']).first

      if version.nil?
        version = ClientVersion.new
        version.era = ClientEra.where(slug: raw_version['era']).first
        version.slug = raw_version['slug']
      end

      version.save!
    end
  end
end

def seed_patches
  puts 'Seeding patches...'

  raw_patches = read_json(relative_path('seeds/client_patches.json'))

  ClientPatch.transaction do
    raw_patches.each do |raw_patch|
      patch = ClientPatch.where(slug: raw_patch['slug']).first

      if patch.nil?
        patch = ClientPatch.new
        patch.version = ClientVersion.where(slug: raw_patch['version']).first
        patch.era = patch.version.era
        patch.slug = raw_patch['slug']
      end

      patch.save!
    end
  end
end

def seed_builds
  puts 'Seeding builds...'

  raw_builds = read_json(relative_path('seeds/client_builds.json'))

  ClientBuild.transaction do
    raw_builds.each do |raw_build|
      build = ClientBuild.where(slug: raw_build['slug']).first

      if build.nil?
        build = ClientBuild.new
        build.patch = ClientPatch.where(slug: raw_build['patch']).first
        build.version = build.patch.version
        build.era = build.version.era
        build.slug = raw_build['slug']
      end

      build.number = raw_build['number']
      build.archive_type = raw_build['archive_type']
      build.released_on = raw_build['released_on']
      build.supported = raw_build['supported'] == true

      build.save!

      # Establish current builds.
      %w(patch version era).each do |level_name|
        level = build.send(level_name)

        if level.current_build.nil? || level.current_build.number < build.number
          level.current_build = build
          level.save!
        end
      end
    end
  end
end

def seed_territory_factions
  puts 'Seeding territory factions...'

  raw_tfs = read_json(relative_path('seeds/territory_factions.json'))

  TerritoryFaction.transaction do
    raw_tfs.each do |raw_tf|
      tf = TerritoryFaction.where(slug: raw_tf['slug']).first

      if tf.nil?
        tf = TerritoryFaction.new
        tf.slug = raw_tf['slug']
      end

      tf.name = raw_tf['name']

      tf.save!
    end
  end
end

def seed_continents
  puts 'Seeding continents...'

  raw_continent_defs = read_json(relative_path('seeds/continents.json'))

  Continent.transaction do
    raw_continent_defs.each do |raw_continent_def|
      client_version = ClientVersion.where(slug: raw_continent_def['version']).first
      raise 'invalid version' if client_version.nil?

      client_version.builds.each do |client_build|
        build_target = client_build.target

        raw_continent_def['continents'].each do |raw_continent|
          continent = Continent.where(target: build_target, slug: raw_continent['slug']).first

          if continent.nil?
            continent = Continent.new
            continent.target = build_target
            continent.slug = raw_continent['slug']
          end

          continent.name = raw_continent['name']

          continent.save!
        end
      end
    end
  end
end

def seed_zones
  puts 'Seeding zones...'

  raw_zone_defs = read_json(relative_path('seeds/zones.json'))

  Zone.transaction do
    raw_zone_defs.each do |raw_zone_def|
      client_version = ClientVersion.where(slug: raw_zone_def['version']).first
      raise 'invalid version' if client_version.nil?

      client_version.builds.each do |client_build|
        build_target = client_build.target

        raw_zone_def['zones'].each do |raw_zone|
          zone = Zone.where(target: build_target, slug: raw_zone['slug']).first

          if zone.nil?
            zone = Zone.new
            zone.target = build_target
            zone.slug = raw_zone['slug']
          end

          zone.continent = Continent.where(target: build_target, slug: raw_zone['continent']).first
          zone.name = raw_zone['name']
          zone.area_eids = raw_zone['area_eids']
          zone.map_eid = raw_zone['map_eid']
          zone.territory_faction = TerritoryFaction.where(slug: raw_zone['faction']).first
          zone.suggested_minimum_level = raw_zone['levels'].first if !raw_zone['levels'].nil?
          zone.suggested_maximum_level = raw_zone['levels'].last if !raw_zone['levels'].nil?

          zone.save!
        end
      end
    end
  end
end

def sync_targets
  puts 'Syncing targets...'
  Target.sync!
end

seed_eras
seed_versions
seed_patches
seed_builds
sync_targets
seed_territory_factions
seed_continents
seed_zones
