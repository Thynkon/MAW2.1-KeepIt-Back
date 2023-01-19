json.apiVersion Rails.configuration.api_version
json.error do
  json.code code
  json.message exception.message
  json.errors do
    json.reason exception.class
    json.message exception.message
  end
end
