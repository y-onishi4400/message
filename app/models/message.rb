class Message < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :text, presence: true, length: { minimum: 1 }
  validates :url_token, presence: true, uniqueness: true

  def to_param
    url_token
  end
end
