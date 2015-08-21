json.draw             @data_table.draw
json.recordsTotal     @data_table.all_results.count
json.recordsFiltered  @data_table.filtered_results.count

json.data do
  json.array! @data_table.final_results do |creature|
    json.DT_RowId           creature.dom_id

    json.url                targeted_url(creature.url)
    json.build              creature.build.number

    json.name               creature.name

    json.areas              creature.areas.pluck(:name).sort

    json.minimum_level      creature.stats.minimum_level
    json.maximum_level      creature.stats.maximum_level
  end
end
