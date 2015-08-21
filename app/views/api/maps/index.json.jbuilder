json.draw             @data_table.draw
json.recordsTotal     @data_table.all_results.count
json.recordsFiltered  @data_table.filtered_results.count

json.data do
  json.array! @data_table.final_results do |map|
    json.DT_RowId   map.dom_id

    json.url        targeted_url(map.url)
    json.build      map.build.number
    json.eid        map.eid

    json.name       map.name

    json.type       map.type.label if !map.type.nil?
  end
end
