json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems 1
  json.items [@book].map do |book|
    json.id book[:id]
    json.title book[:title]
    json.description book[:description]
    json.authors book[:authors]
    json.cover book[:cover]
    json.subjects book[:subjects]
    json.language book[:language]
    json.number_of_pages book[:number_of_pages]
    json.published_at book[:published_at]
    json.upvotes book[:upvotes]
    json.downvotes book[:downvotes]
  end
end
