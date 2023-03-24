json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @book[:id]
    json.title @book[:title]
    json.description @book[:description]
    json.authors @book[:authors]
    json.cover @book[:cover]
    json.subjects @book[:subjects]&.map { |subject| subject.split('/') }&.flatten&.uniq
    json.language @book[:language]
    json.number_of_pages @book[:number_of_pages]
    json.published_at @book[:published_at]
    json.upvotes @book[:upvotes]
    json.downvotes @book[:downvotes]

    json.user_vote @user_votes_book ? @user_votes_book.vote : 0
    json.user_page @user_reads_book ? @user_reads_book.page : 0
  end
end
