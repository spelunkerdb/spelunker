require 'fileutils'

require_relative '../../../wow-data/wow'

require_relative 'build_importer/dbc_imports'
require_relative 'build_importer/definition_imports'
require_relative 'build_importer/map_data_imports'

class BuildImporter
  include DBCImports
  include DefinitionImports
  include MapDataImports

  attr_reader :build, :target

  def initialize(build_number, build_path)
    @build = ClientBuild.where(number: build_number).first
    raise 'Unknown client build' if @build.nil?
    raise 'Unsupported build' if !@build.supported?

    @target = @build.target

    @build_path = build_path
    raise 'Build path does not exist' if !File.directory?(@build_path)
  end

  def build_path_for(path)
    "#{@build_path}/#{path}"
  end

  def dbc_path_for(path)
    build_path_for("DBFilesClient/#{path}")
  end

  def map_path_for(path)
    build_path_for("World/Maps/#{path}")
  end

  def file_hash(path)
    hash = Digest::SHA256.file(path).hexdigest
  end

  # Given a potentially messy string value, produce a reasonably consistent slug for use in
  # identifying a record via a URL.
  def value_to_slug(value)
    value = value.to_s.dup

    # Ensure all whitespace is squeezed and replaced by underscores.
    value.gsub!(/\r|\n/, ' ')
    value.squeeze!(' ')
    value.gsub!(/ /, '_')
    value.squeeze!('_')

    # Ensure all SnakeCasing is replaced by underscores.
    value = value.underscore

    # Ensure all underscores are replaced by dashes and all dashes are squeezed.
    value.gsub!(/_/, '-')
    value.squeeze!('-')

    value
  end

  def import!
    puts "Importing build #{@build.number}..."

    #import_definitions!
    #import_dbcs!
    import_map_data!
  end
end
