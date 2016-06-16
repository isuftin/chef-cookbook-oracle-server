# Added by ChefSpec
require 'chefspec'
require 'chefspec/berkshelf'


RSpec.configure do |config|

end

at_exit { ChefSpec::Coverage.report! }
