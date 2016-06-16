require 'spec_helper.rb'

describe group('oinstall') do
  it { should exist }
end

describe user('oracle') do
  it { should exist }
  it { should belong_to_group 'oinstall' }
end

describe file('/home/oracle') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end
