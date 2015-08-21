private def import_packet(packet)
  return if packet.opcode.nil?

  if @capture.packets.where(index: packet.index).exists?
    packet_record = @capture.packets.at_index(packet.index)
  else
    packet_record = @capture.packets.new
    packet_record.index = packet.index
  end

  if packet.direction.to_sym == :SMSG
    packet_record.opcode = Opcode.smsg.in_build(@build).at_index(packet.opcode.index)
  elsif packet.direction.to_sym == :CMSG
    packet_record.opcode = Opcode.cmsg.in_build(@build).at_index(packet.opcode.index)
  else
    raise 'unexpected packet direction!'
  end

  packet_record.packet_tick = packet.tick
  packet_record.packet_time = packet.time

  packet_record.save!
end
