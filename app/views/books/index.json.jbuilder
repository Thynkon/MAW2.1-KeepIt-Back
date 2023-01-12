json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems @books.length
  json.items  @books.map do |book|
    json.id book[:id]
    json.title book[:title]
    json.cover book[:cover]
    json.published_at book[:published_at]
    json.upvotes book[:upvotes]
    json.downvotes book[:downvotes]
  end
end
