module DefinitionImports
  def import_definitions!
    select_definitions
    import_map_type_definitions
  end

  private def select_definitions
    puts "Selecting matching definitions..."

    truncated_builds = ClientBuild.up_to(@build.number).order('number DESC').pluck('number')
    definitions = nil
    matched_build = nil

    # Find the first existing definitions walking down from the actual build number.
    truncated_builds.each do |potential_match|
      result = WOW::Capture::Definitions.for_build(potential_match)

      if !result.nil?
        matched_build = potential_match
        definitions = result
        break
      end
    end

    if definitions.nil?
      puts "-> Could not find matching definitions. Aborting!"
      exit
    end

    puts "-> Using matching definitions: #{matched_build}"

    @definitions = definitions
  end

  private def import_map_type_definitions
    puts "-> Importing map types..."
    import_standard_definitions(definitions.map_types, MapType, %i(value label))
  end

  private def import_standard_definitions(entries, klazz, attributes)
    klazz.transaction do
      entries.each do |entry|
        record = klazz.target(target).at_entry(entry.index)

        if record.nil?
          record = klazz.new
          record.target = target
          record.eid = entry.index
        end

        attributes.each do |attribute|
          if attribute == :value
            record.value = entry.value
            record.slug = value_to_slug(entry.value)
          else
            record.send("#{attribute}=", entry.send(attribute))
          end
        end

        record.save!
      end
    end
  end

  private def definitions
    @definitions
  end
end
