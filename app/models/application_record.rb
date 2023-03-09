class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class_attribute :serializable_fields

  # https://apidock.com/rails/ActiveModel/Serialization/serializable_hash
  # This method is used for any kind of serialization (JSON, XML, etc)
  def serializable_hash(_options = nil)
    super(only: serializable_fields)
  end
end
