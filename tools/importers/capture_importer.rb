require 'fileutils'

require_relative '../../../wow-data/wow'

require_relative 'capture_importer/creature_imports'

class CaptureImporter
  include CreatureImports

  def initialize(capture_path)
    @capture_path = capture_path
    raise "Path does not exist!" if !File.exist?(@capture_path)
  end

  def setup!
    @parser = WOW::Capture::Parser.new(@capture_path)

    @client_build = ClientBuild.where(number: @parser.client_build).first
    raise 'unknown build' if @client_build.nil?
    raise 'unsupported build' if !@client_build.supported?

    @target = @client_build.target

    @capture = find_or_create_capture

    # Order matters.
    #setup_packet_subscriptions
    setup_creature_subscriptions
    #setup_reference_subscriptions
  end

  def import!
    puts "Importing from capture: #{@capture_path}..."

    puts '-> Replaying capture...'

    @parser.replay!

    # Update packets count now that we've reached the end of the capture.
    @capture.packets_count = @parser.packet_index
    @capture.save!

    import_creature_instances
  end

  def find_or_create_capture
    file_hash = Digest::SHA256.file(@capture_path).hexdigest
    existing_capture = Capture.where(file_hash: file_hash).first

    return existing_capture if !existing_capture.nil?

    file_name = @capture_path.split('/').last
    file_size = File.size(@capture_path)

    @capture = Capture.new
    @capture.target = @target
    @capture.file_hash = file_hash
    @capture.file_name = file_name
    @capture.file_size = file_size
    @capture.save!

    @capture
  end

  <<-eos
  def setup_packet_subscriptions
    @parser.on(:packet) do |packet|
      Packet.transaction do
        import_packet(packet)
      end
    end
  end
  eos

  def setup_creature_subscriptions
    @parser.on(:packet, direction: :SMSG, opcode: :QueryCreatureResponse) do |packet|
      Creature.transaction do
        import_from_creature_query(packet)
      end
    end
  end

  <<-eos
  def setup_reference_subscriptions
    @parser.on(:packet) do |packet|
      next if !packet.has_references?

      packet.references.each do |reference|
        import_reference(reference)
      end
    end
  end
  eos
end
