# frozen_string_literal: true

module ActiveStorageHelpers
  def file_fixture_image(name = 'img.jpg')
    path = Rails.root.join('spec/fixtures/files', name)
    Rack::Test::UploadedFile.new(path, "image/jpeg")
  end
end

RSpec.configure do |config|
  config.include ActiveStorageHelpers
end
