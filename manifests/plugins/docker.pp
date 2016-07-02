# docker plugin
#
class collectd::plugins::docker (
    $modules,
    $pip_name
) {
  validate_hash($modules)
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  include collectd
  
  $temp_docker_plugin_setup_location = "/tmp/signalfx-puppet/docker"
  $temp_docker_plugin_setup_file = "${temp_docker_plugin_setup_location}/python_dependencies_installation.txt"
  
  collectd::get_from_github { $title:
    localfolder => '/usr/share/collectd/python/docker-collectd-plugin',
    source      => 'https://github.com/signalfx/docker-collectd-plugin.git'
  } ->
  exec { "install python dependencies":
    command => "${pip_name} install -r /usr/share/collectd/python/docker-collectd-plugin/requirements.txt &&
                 mkdir -p ${temp_docker_plugin_setup_location} &&
                 echo 'This file allows Signalfx to check if python dependencies for docker plugin are setup properly' > ${temp_docker_plugin_setup_file}",
    unless => "test -f ${temp_docker_plugin_setup_file}"
  } ->
  collectd::plugins::plugin_common { 'docker':
    package_name         => 'collectd-python',
    plugin_file_name     => '10-docker.conf',
    plugin_template_name => 'docker.conf.erb'
  }
}
