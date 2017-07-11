Puppet::Parser::Functions.newfunction(:get_dimensions, :type => :rvalue) do |args|
dimension_list = args[0]
aws_integration = args[1]
dimensions = "?"
if aws_integration
        puts "Getting AWS metadata..."
        uri = URI.parse("http://169.254.169.254/2014-11-05/dynamic/instance-identity/document")
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 4
        http.read_timeout = 4
        begin
                http.start
                begin
                        response = http.request(Net::HTTP::Get.new(uri.request_uri))
                rescue Timeout::Error
                       puts "ERROR: Unable to get AWS metadata, Timeout due to reading"
                rescue Exception
                       puts "ERROR: Unable to get AWS metadata, exception occurred!"
                end
        rescue Timeout::Error
                puts "ERROR: Unable to get AWS metadata, Timeout due to connecting"
        rescue Exception
                puts "ERROR: Unable to get AWS metadata, exception occurred!"
        end
        unless response.nil? || response == 0
                result = JSON.parse(response.body)
                dimensions << "sfxdim_AWSUniqueId=#{result["instanceId"]}_#{result["region"]}_#{result["accountId"]}&"
        end
end
unless dimension_list.empty?
    dimension_list.sort_by { |k| k }.each { |key, value| dimensions << "sfxdim_#{key}=#{value}&" }
end
dimensions[0...-1]
end
