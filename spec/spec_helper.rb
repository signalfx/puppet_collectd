require 'puppetlabs_spec_helper/module_spec_helper'

def verify_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  expect(content.split("\n") & expected_lines).to match_array expected_lines.uniq
end

RSpec.configure do |c|
  c.default_facts = {
    :osfamily        => 'RedHat',
    :operatingsystem => 'RedHat',
    :operatingsystemmajrelease => '7',
    :facterversion             => '2.4.6',
  }
end
