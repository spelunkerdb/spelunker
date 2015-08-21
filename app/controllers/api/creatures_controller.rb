class Api::CreaturesController < ApiController
  def index
    @data_table = DataTables::CreaturesIndexTable.new(self)
  end

  def level_stats
    @data_table = DataTables::CreatureLevelStatsTable.new(self)
  end

  def instances
    @data_table = DataTables::CreatureInstancesTable.new(self)
  end
end
