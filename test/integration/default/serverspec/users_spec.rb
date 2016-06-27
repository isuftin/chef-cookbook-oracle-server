require 'spec_helper.rb'

%w{ oinstall dba }.each do |g|
  describe group(g) do
    it { should exist }
  end
end


describe user('oracle') do
  it { should exist }
  it { should belong_to_group 'oinstall' }
  it { should belong_to_group 'dba' }
end

describe file('/home/oracle') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe file('/home/oracle/.bash_profile') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end
