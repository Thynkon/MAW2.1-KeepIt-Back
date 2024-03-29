json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems @achievements.length
  json.items  @achievements.map do |achievement|
    json.id achievement[:id]
    json.title achievement[:title]
    json.description achievement[:description]
    json.percentage rand(0..100) # TODO: replace with real value
    json.created_at achievement[:created_at]
  end
end
