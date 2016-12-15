require 'net/http'
uri = URI.parse('http://169.254.169.254/2014-11-05/dynamic/instance-identity/document')
http = Net::HTTP.new(uri.host, uri.port)
http.open_timeout = 4
http.read_timeout = 4
begin
  http.start
  response = http.request(Net::HTTP::Get.new(uri.request_uri))
rescue StandardError
  raise 'Unable to reach AWS metadata'
end
unless response.nil? || response == 0
  Facter.add('ec2_instance_identity_document') do
    setcode do
      JSON.parse(response.body).to_json
    end
  end
end
