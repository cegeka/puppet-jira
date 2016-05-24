  require 'spec_helper_acceptance'

describe 'apache' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      class { '::jira':
        javahome => '/opt/java/latest',
        db       => 'mysql',
        dbport   => '3306',
        dbdriver => 'com.mysql.jdbc.Driver',
        dbtype   => 'mysql',
      }
    
      include ::jira::facts
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
