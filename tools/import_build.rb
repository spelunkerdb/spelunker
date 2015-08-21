# Import Build
#
# Imports the data for a given build into appropriate models within Spelunker. The build import
# process can be run multiple times-- data will not be duplicated or corrupted.
#
# Please note that importing a build is time consuming and demands a fair bit of memory. Ideally,
# the database server set up for Spelunker should reside on some powerful and separate hardware,
# so importing doesn't unnecessarily thrash the disk.
#
# This tool expects a client data to exist in a directory one level above the spelunker directory,
# with a directory name of client-data. Each build's client data should be placed in a subdirectory
# of the client-data directory, with directory names matching the build number.
#
# Use third party tools to extract the base assets from the World of Warcraft client directory.
#
# Usage Examples:
#
# ruby import_build.rb 20338
# ruby import_build.rb all
#

require_relative '../config/environment'
require_relative 'importers/build_importer'

def import_build(number)
  path = File.expand_path("../../../client-data/#{number}", __FILE__)
  importer = BuildImporter.new(number, path)
  importer.import!
end

import_build(ARGV[0])
