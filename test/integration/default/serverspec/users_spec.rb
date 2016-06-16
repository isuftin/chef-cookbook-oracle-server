require 'spec_helper.rb'

describe group('oinstall') do
  it { should exist }
end

describe user('oracle') do
  it { should exist }
  it { should belong_to_group 'oinstall' }
end
