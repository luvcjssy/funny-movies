class Video < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :url, presence: true, url: true
  validate :validate_youtube_url

  private

  def validate_youtube_url
    errors.add(:url, 'is not youtube URL') unless url.include?('youtube') || url.include?('youtu.be')
  end
end
