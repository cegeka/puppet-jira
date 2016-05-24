  require 'spec_helper_acceptance'

describe 'apache' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS

      include 'yum'
      include 'cegekarepos'
      include 'profile::package_management'
      Yum::Repo <| title == 'cegeka-unsigned' |>
      sunjdk::instance { 'jdk-1.8.0_05-fcs':
        ensure      => 'present',
        jdk_version => '1.8.0_05-fcs'
      }

      class { 'jira':
        version      => '7.1.7',
        checksum     => 'aa17cef91b910f8a112a51c769c89f3f',
        javahome     => '/usr/java/jdk1.8.0_05',
      }
      class { 'jira::facts': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8080) do
      it { is_expected.to be_listening }
    end

    describe service('jira') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
