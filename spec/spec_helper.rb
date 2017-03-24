# Added by ChefSpec
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.file_cache_path = '/tmp/kitchen/cache'
  config.platform = 'centos'
  config.version = '6.7'
end

at_exit { ChefSpec::Coverage.report! }
