require 'spec_helper.rb'

describe file('/home/oracle/local_response.rsp') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe file('/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1/dbs/initadmin.ora') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

describe file('/etc/security/limits.d/91-file-limits.conf') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

%w{ /home/oracle/database /u01/oradata/auto /u01/oradata/auto/oraInventory/ /u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1 }.each do |f|
  describe file(f) do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'oracle' }
    it { should be_grouped_into 'oinstall' }
  end
end

describe file('/u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1/root.sh') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oinstall' }
end

[
  'ulimit -Hn | grep -q 65536',
  'ulimit -n | grep -q 1024',
  'ps -ef|pgrep  pmon'
].each do |c|
  describe command(c) do
    its(:exit_status) { should eq 0 }
  end
end
