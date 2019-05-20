Puppet::Parser::Functions.newfunction(:get_dimensions, type: :rvalue) do |args|
  dimension_list = args[0]
  aws_integration = args[1]
  dimensions = '?'

  if aws_integration
    document = lookupvar('ec2_instance_identity_document')
    if document
      result = JSON.parse(document)
      dimensions << "sfxdim_AWSUniqueId=#{result['instanceId']}_#{result['region']}_#{result['accountId']}&"
    end
  end
  unless dimension_list.empty?
    dimension_list.each { |key, value| dimensions << "sfxdim_#{key}=#{value}&" }
  end
  dimensions[0...-1]
end
