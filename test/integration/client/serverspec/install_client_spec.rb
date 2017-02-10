require 'spec_helper.rb'

describe file('/usr/lib/oracle/12.1/client64/lib') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe package('oracle-instantclient12.1-jdbc') do
  it { should be_installed }
end

describe package('oracle-instantclient12.1-basic') do
  it { should be_installed }
end

describe package('oracle-instantclient12.1-sqlplus') do
  it { should be_installed }
end

describe file('/usr/bin/sqlplus64') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_symlink }
  it { should be_linked_to '/usr/lib/oracle/12.1/client64/bin/sqlplus' }
  it { should be_executable }
end
