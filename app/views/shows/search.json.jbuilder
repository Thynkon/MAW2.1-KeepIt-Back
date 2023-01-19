json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.page @shows[:page]
  json.totalPages @shows[:total_pages]
  json.totalItems @shows[:total_items]
  json.results  @shows[:results]
end