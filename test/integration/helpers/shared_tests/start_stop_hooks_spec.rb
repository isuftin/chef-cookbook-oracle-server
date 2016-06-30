require 'spec_helper.rb'

describe file("/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1/network/admin/listener.ora") do
  it { should exist }
  it { should be_file }
  it { should be_mode 664 }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe file("/etc/init.d/oracle") do
  it { should exist }
  it { should be_file }
  it { should be_mode 751 }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe file("/etc/oratab") do
  it { should exist }
  it { should be_file }
  it { should be_mode 664 }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe command('sudo chkconfig | grep -q oracle') do
  its(:exit_status) { should eq 0 }
end
