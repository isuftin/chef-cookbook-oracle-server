require 'spec_helper.rb'

describe file('/home/oracle/local_response.rsp') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe file('/home/oracle/init.ora') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end
