require_relative '../config/environment'
require_relative 'importers/capture_importer'

def import_capture(filename)
  path = File.expand_path("../../uploads/captures/#{filename}", __FILE__)
  importer = CaptureImporter.new(path)
  importer.setup!
  importer.import!
end

import_capture(ARGV[0])
