json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.page @movies[:page]
  json.totalPages @movies[:total_pages]
  json.totalItems @movies[:total_items]
  json.results  @movies[:results]
end