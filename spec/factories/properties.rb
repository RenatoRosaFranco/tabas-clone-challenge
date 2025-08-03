# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    sequence(:name) { |n| "Property #{n}" }

    transient do
      images_count     { 3 }
      images_filenames { %w[img1.jpg img2.jpg img3.jpg] }
    end

    trait :with_images do
      after(:build) do |property, evaluator|
        base_path = Rails.root.join("spec/fixtures/files")

        files =
          Array(evaluator.images_filenames)
            .first(evaluator.images_count.to_i)
            .map { |fname| Rack::Test::UploadedFile.new(base_path.join(fname), "image/jpeg") }

        property.photos.attach(files) if files.any?
      end
    end

    trait :invalid do
      name { nil }
    end
  end
end
