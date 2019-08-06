require "bundler/setup"

# Disable Vagrant autoloading so that other plugins defined in the Gemfile for
# Acceptance tests are not loaded.
ENV['VAGRANT_NO_PLUGINS'] = '1'

require 'vagrant-spec/unit'
require 'vagrant-haipa'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
