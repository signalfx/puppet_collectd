# Contains important parameters, urls
#
class collectd::params {
        $fqdnlookup             = true
        $hostname               = $::hostname
        $interval               = 10
        $timeout                = 2
        $read_threads           = 5
        $write_queue_limit_high = 500000
        $write_queue_limit_low  = 400000
        $collect_internal_stats = true
        $log_file               = '/var/log/signalfx-collectd.log'
        $log_level              = 'info'
        $loadplugins            = {}
        $ensure_signalfx_plugin_version = present
        $dimension_list            = {}
        $signalfx_api_endpoint     = 'https://ingest.signalfx.com/v1/collectd'
        $write_http_timeout        = 3000
        $write_http_buffersize     = 65536
        $aws_integration           = true
        $write_http_log_http_error = true
        $write_http_flush_interval = 10
        $manage_service            = true

        $signalfx_plugin_log_traces               = true
        $signalfx_plugin_interactive              = false
        $signalfx_plugin_notifications            = true
        $signalfx_plugin_notify_level             = 'OKAY'
        $signalfx_plugin_dpm                      = false
        $signalfx_plugin_utilization              = true
        $signalfx_plugin_cpu_utilization          = true
        $signalfx_plugin_cpu_utilization_per_core = true
        $filter_default_metrics                   = false
        $filter_default_metric_rules              = {}
        $use_default_cpu_plugin                   = true
        $use_default_cpufreq_plugin               = true
        $use_default_df_plugin                    = true
        $use_default_disk_plugin                  = true
        $use_default_interface_plugin             = true
        $use_default_load_plugin                  = true
        $use_default_memory_plugin                = true
        $use_default_protocols_plugin             = true
        $use_default_vmem_plugin                  = true
        $use_default_uptime_plugin                = true

        # Do not change these values, they are here for code reuse
        if $::osfamily == 'Debian' {
          $plugin_config_dir_tree      = ['/etc/collectd/', '/etc/collectd/managed_config', '/etc/collectd/filtering_config']
          $include_plugin_dirs         = ['/etc/collectd/managed_config', '/etc/collectd/filtering_config']
          $plugin_config_dir           = '/etc/collectd/managed_config'
          $collectd_config_file        = '/etc/collectd/collectd.conf'
          $filtering_config_file       = '/etc/collectd/filtering_config/filtering.conf'
          $mysql_socket_file           = '/var/lib/mysqld/mysqld.sock'
        }
        elsif $::osfamily == 'Redhat' {
          $plugin_config_dir_tree     = ['/etc/collectd.d/', '/etc/collectd.d/managed_config', '/etc/collectd.d/filtering_config']
          $include_plugin_dirs        = ['/etc/collectd.d/managed_config', '/etc/collectd.d/filtering_config']
          $plugin_config_dir          = '/etc/collectd.d/managed_config'
          $collectd_config_file       = '/etc/collectd.conf'
          $filtering_config_file      = '/etc/collectd.d/filtering_config/filtering.conf'
          $mysql_socket_file          = '/var/lib/mysql/mysql.sock'
        }

        case $::operatingsystem {
                'Ubuntu':{
                    $signalfx_public_keyid = 'C94EDC608899B00511CCBA4D68EA6297FE128AB0' # public key to repository hosted on launchpad
                    $signalfx_collectd_repo_source  = 'ppa:signalfx/collectd-release'
                    $signalfx_plugin_repo_source    = 'ppa:signalfx/collectd-plugin-release'
                }
                'Debian':{
                    case $::operatingsystemmajrelease {
                        '7': {
                              $signalfx_public_keyid          = '91668001288D1C6D2885D651185894C15AE495F6' # public key to repository hosted on AWS S3
                              $signalfx_collectd_repo_source  = 'deb https://dl.signalfx.com/debs/collectd/wheezy/release /'
                              $signalfx_plugin_repo_source    = 'deb https://dl.signalfx.com/debs/signalfx-collectd-plugin/wheezy/release /'
                        }
                        '8': {
                              $signalfx_public_keyid          = '91668001288D1C6D2885D651185894C15AE495F6' # public key to repository hosted on AWS S3
                              $signalfx_collectd_repo_source  = 'deb https://dl.signalfx.com/debs/collectd/jessie/release /'
                              $signalfx_plugin_repo_source    = 'deb https://dl.signalfx.com/debs/signalfx-collectd-plugin/jessie/release /'
                        }
                        '9': {
                              $signalfx_public_keyid          = '91668001288D1C6D2885D651185894C15AE495F6' # public key to repository hosted on AWS S3
                              $signalfx_collectd_repo_source  = 'deb https://dl.signalfx.com/debs/collectd/stretch/release /'
                              $signalfx_plugin_repo_source    = 'deb https://dl.signalfx.com/debs/signalfx-collectd-plugin/stretch/release /'
                        }
                        default: {
                                fail("Your Debian OS major release : ${::operatingsystemmajrelease} is not supported.")
                        }
                    }
                }
                'RedHat', 'CentOS': {
                    $signalfx_collectd_repo_filename = '/etc/yum.repos.d/SignalFx-collectd-RPMs-centos-7-release.repo' # file created in /etc/yum.repos.d
                    $signalfx_plugin_repo_filename = '/etc/yum.repos.d/SignalFx-collectd_plugin-RPMs-centos-release.repo' # file created in /etc/yum.repos.d
                    case $::operatingsystemmajrelease {
                        '7': {
                            $old_signalfx_collectd_repo_source   = 'SignalFx-collectd-RPMs-centos-7-release'
                            $signalfx_collectd_repo_source       = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd-RPMs-centos-7-release-latest.noarch.rpm'
                            $signalfx_plugin_repo_source         = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-centos-release-latest.noarch.rpm'
                        }
                        '6': {
                            $old_signalfx_collectd_repo_source   = 'SignalFx-collectd-RPMs-centos-6-release'
                            $signalfx_collectd_repo_source       = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd-RPMs-centos-6-release-latest.noarch.rpm'
                            $signalfx_plugin_repo_source         = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-centos-release-latest.noarch.rpm'
                        }
                        default: {
                            fail("Your OS major release : ${::operatingsystemmajrelease} is not supported.")
                        }
                    }
                }
                'Amazon': {
                        $signalfx_collectd_repo_filename = '/etc/yum.repos.d/SignalFx-collectd-RPMs-AWS_EC2_Linux-release.repo' # file created in /etc/yum.repos.d
                        $signalfx_plugin_repo_filename = '/etc/yum.repos.d/SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux-release.repo' # file created in /etc/yum.repos.d
                        $signalfx_collectd_repo_source       = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd-RPMs-AWS_EC2_Linux-release-latest.noarch.rpm'
                        $signalfx_plugin_repo_source         = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux-release-latest.noarch.rpm'
                        case $::operatingsystemrelease {
                            '2016.03', '2016.09', '2017.03', '2017.09', '2017.12', '2018.03': {
                                # No old_signalfx_collectd_repo_source on newer Amazon Linux versions
                            }
                            '2015.09': {
                                $old_signalfx_collectd_repo_source   = 'SignalFx-collectd-RPMs-AWS_EC2_Linux_2015_09-release'
                            }
                            '2015.03': {
                                $old_signalfx_collectd_repo_source   = 'SignalFx-collectd-RPMs-AWS_EC2_Linux_2015_03-release'
                            }
                            '2014.09': {
                                $old_signalfx_collectd_repo_source   = 'SignalFx-collectd-RPMs-AWS_EC2_Linux_2014_09-release'
                            }
                            default: {
                              if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
                                fail("Your facter version ${::facterversion} is not supported by our module. More info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
                              }else {
                                  fail("Your operating system release : ${::operatingsystemrelease} is not supported.")
                              }
                            }
                        }
                }
                default: {
                        fail("Your operating system : ${::operatingsystem} is not supported.")
                }
        }
}
