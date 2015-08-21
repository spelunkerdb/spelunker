class Api::ZonesController < ApiController
  def index
    @data_table = DataTables::ZonesIndexTable.new(self)
  end

  def creatures
    @data_table = DataTables::ZoneCreaturesTable.new(self)
  end
end
