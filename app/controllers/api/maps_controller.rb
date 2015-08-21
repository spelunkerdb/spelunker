class Api::MapsController < ApiController
  def index
    @data_table = DataTables::MapsIndexTable.new(self)
  end
end
