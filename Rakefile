require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'

PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_arrow_on_right_operand_line')

task :default => [:lint, :syntax]
