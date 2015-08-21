json.draw             @data_table.draw
json.recordsTotal     @data_table.all_results.count
json.recordsFiltered  @data_table.filtered_results.count

json.data do
  json.array! @data_table.final_results do |level_stats|
    json.level              level_stats.level

    json.minimum_health     level_stats.minimum_health
    json.maximum_health     level_stats.maximum_health
    json.average_health     level_stats.average_health

    json.minimum_power      level_stats.minimum_power
    json.maximum_power      level_stats.maximum_power
    json.average_power      level_stats.average_power
  end
end
