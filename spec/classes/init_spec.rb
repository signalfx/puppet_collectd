require 'spec_helper'

oses = {
  :supported_os => [
    {
      'osfamily'        => 'Debian',
      'operatingsystem' => 'Debian',
      'operatingsystemrelease' => ['7', '8'],
    },
    {
      'osfamily'        => 'RedHat',
      'operatingsystem' => 'RedHat',
      'operatingsystemrelease' => ['6', '7'],
    },
    {
      'osfamily'        => 'RedHat',
      'operatingsystem' => 'Amazon',
      'operatingsystemrelease' => ['2016.03', '2015.09', '2015.03', '2014.09'],
    },
  ],
}

describe 'collectd' do
  on_supported_os(oses).each do |os, facts|
    context "on #{os}" do
      let(:params) do
        {
          :signalfx_api_token => 'MY API TOKEN',
          :aws_integration    => false,
        }
      end

      let(:facts) do
        facts
      end

      it {
        is_expected.to compile.with_all_deps
      }
    end
  end

  context 'RedHat 7' do
    let(:params) do
      {
        :signalfx_api_token => 'MY API TOKEN',
        :aws_integration    => false,
      }
    end

    let(:facts) do
      {
        :osfamily        => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '7',
      }
    end

    it {
      is_expected.to contain_exec('update_system').with({
        'command' => 'yum -y update',
        'unless'  => 'which collectd',
      })
    }

    it {
      is_expected.to contain_package('SignalFx-collectd-RPMs-centos-7-release').with({
        'ensure' => 'absent',
      })
    }

    it {
      is_expected.to contain_exec('Add https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd-RPMs-centos-release-latest.noarch.rpm, https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-centos-release-latest.noarch.rpm').with({
        'command' => 'yum install -y https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd-RPMs-centos-release-latest.noarch.rpm https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-centos-release-latest.noarch.rpm',
        'unless'  => 'test -s /etc/yum.repos.d/SignalFx-collectd-RPMs-centos-release.repo && test -s /etc/yum.repos.d/SignalFx-collectd_plugin-RPMs-centos-release.repo',
      })
    }

    it {
      is_expected.to contain_package('collectd').with({
        'ensure'   => 'present',
        'provider' => 'yum',
      })
    }

    it {
      is_expected.to contain_package('collectd-disk').with({
        'ensure'   => 'present',
        'provider' => 'yum',
      })
    }

    it {
      is_expected.to contain_file('/var/log/signalfx-collectd.log').with({
        'ensure' => 'present',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/etc/collectd.d/').with({
        'path'   => '/etc/collectd.d',
        'ensure' => 'directory',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/etc/collectd.d/managed_config').with({
        'ensure' => 'directory',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/etc/collectd.d/filtering_config').with({
        'ensure' => 'directory',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/etc/collectd.conf').with({
        'notify' => 'Service[collectd]',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/etc/collectd.d/filtering_config/filtering.conf').with({
        'mode'  => '0755',
        'owner' => 'root',
        'group' => 'root',
      })
    }

    it {
      is_expected.to contain_file('load write_http plugin').with({
        'ensure' => 'present',
        'path'   => '/etc/collectd.d/managed_config/10-write_http.conf',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
    }

    [

"<LoadPlugin \"write_http\">
   FlushInterval 10
</LoadPlugin>
<Plugin \"write_http\">
    <Node \"signalfx\">
        URL \"https://ingest.signalfx.com/v1/collectd\"
        User \"auth\"
        Password \"MY API TOKEN\"
        Format \"JSON\"
        Timeout 3000
        BufferSize 65536
        LogHttpError true
    </Node>
</Plugin>
",

    ].map{|k| k.split("\n")}.each do |text|

      it {
        verify_contents(catalogue, 'load write_http plugin', text)
      }
    end

    it {
      is_expected.to contain_file('load Signalfx plugin').with({
        'ensure' => 'present',
        'path'   => '/etc/collectd.d/managed_config/10-signalfx.conf',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
    }

    [

"LoadPlugin python
TypesDB \"/opt/signalfx-collectd-plugin/types.db.plugin\"
<Plugin python>
  ModulePath \"/opt/signalfx-collectd-plugin\"
  LogTraces true
  Interactive false
  Import \"signalfx_metadata\"
  <Module signalfx_metadata>
    URL \"https://ingest.signalfx.com/v1/collectd\"
    Token \"MY API TOKEN\"
    Notifications true
    NotifyLevel \"OKAY\"
    DPM false
    Utilization true
  </Module>
</Plugin>
",

    ].map{|k| k.split("\n")}.each do |text|

      it {
        verify_contents(catalogue, 'load Signalfx plugin', text)
      }
    end

    it {
      is_expected.to contain_service('collectd').with({
        'ensure' => 'running',
      })
    }

    it {
      is_expected.to contain_file('/usr/share/collectd/').with({
        'ensure' => 'directory',
        'path'   => '/usr/share/collectd',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/usr/share/collectd/java').with({
        'ensure' => 'directory',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('/usr/share/collectd/python').with({
        'ensure' => 'directory',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      })
    }

    it {
      is_expected.to contain_file('load 10-aggregation-cpu.conf plugin config').with({
        'ensure' => 'present',
        'path'   => '/etc/collectd.d/managed_config/10-aggregation-cpu.conf',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
    }

    [

"# Generated by Puppet
# Install:
#   This plugin is bundled with collectd version 5.2+

# Documentation:
#   The purpose of this module is to aggregate CPU stats from all cores.
#
#   https://collectd.org/wiki/index.php/Plugin:Aggregation
#   https://collectd.org/wiki/index.php/Plugin:Aggregation/Config
#
#   See filtering_config/filtering.conf on filtering out the cpu metrics

# System modifications:
#   None

# Config file modifications:
#   None

LoadPlugin aggregation

<Plugin \"aggregation\">
  <Aggregation>
    Plugin \"cpu\"
    Type \"cpu\"

    GroupBy \"Host\"
    GroupBy \"TypeInstance\"

    CalculateSum true
    CalculateAverage true
  </Aggregation>
</Plugin>
",

    ].map{|k| k.split("\n")}.each do |text|

      it {
        verify_contents(catalogue, 'load 10-aggregation-cpu.conf plugin config', text)
      }
    end

    it {
      is_expected.to contain_package('collectd-write_http').with({
        'ensure' => 'present',
      })
    }

    it {
      is_expected.to contain_package('signalfx-collectd-plugin').with({
        'ensure' => 'present',
      })
    }

    it {
      is_expected.to contain_package('collectd-python').with({
        'ensure' => 'present',
      })
    }

    it {
      File.write(
        'collectd.json',
        PSON.pretty_generate(catalogue)
      )
    }
  end
end
