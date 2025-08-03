# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.cleaning { example.run }
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.cleaning { example.run }
    end
  end
end
