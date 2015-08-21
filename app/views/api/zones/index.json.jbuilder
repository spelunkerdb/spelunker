json.draw             @data_table.draw
json.recordsTotal     @data_table.all_results.count
json.recordsFiltered  @data_table.filtered_results.count

json.data do
  json.array! @data_table.final_results do |zone|
    json.DT_RowId           zone.dom_id

    json.url                targeted_url(zone.url)
    json.build              zone.build.number

    json.continent          zone.continent.name
    json.name               zone.name
    json.territory_faction  zone.territory_faction.nil? ? nil : zone.territory_faction.name

    json.suggested_minimum_level zone.suggested_minimum_level
    json.suggested_maximum_level zone.suggested_maximum_level
  end
end
