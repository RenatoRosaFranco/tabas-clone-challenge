# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Property < ApplicationRecord
  # Uploader
  has_many_attached :photos

  # Validations
  validates :name, presence: true
  validate :minimum_photos_count

  # Methods
  def cover_photo
    photos[2]
  end

  def photos?
    photos.attached?
  end

  private

  def minimum_photos_count
    count = photos.attachments.size
    return if count >= 3

    errors.add(:photos, "devem ter no mínimo 3 arquivos (atualmente #{count})")
  end
end
