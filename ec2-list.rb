require 'aws-sdk'
require 'formatador'
require 'optparse'

class Ec2List
  def initialize(opts)
    @profile = opts[:profile] || 'default'
    @region = opts[:region] || 'ap-northeast-1'
    @status = opts[:status] ||= 'running'
    Aws.config[:credentials] = Aws::SharedCredentials.new(profile_name: @profile)
  end

  def ec2
    @ec2 ||= Aws::EC2::Client.new region: @region
  end

  def result
    instances.map { |instance|
      {
        id: instance.instance_id,
        type: instance.instance_type,
        launched_at: instance.launch_time.localtime,
        tag: instance.tags.find { |tag| tag.key == 'Name' }.value,
        fqdn: instance.public_dns_name,
        ip_addr: instance.public_ip_address
      }
    }.sort_by { |x| x[:tag] }
  end

  def values(key)
    result.map { |x| x[key.to_sym] }.sort
  end

  def reservations
    ec2.describe_instances(filters: [filter]).reservations
  end
  
  def instances
    ec2.describe_instances(filters: [filter]).reservations.map { |x| x.instances }.flatten
  end

  def filter
    {
      name: 'instance-state-name',
      values: [@status]
    }
  end
end

opt = OptionParser.new

opt.on('-p profile') { |v| @profile = v }
opt.on('-r region') { |v| @region = v }
opt.on('-k key') { |v| @key = v }
opt.parse!(ARGV)

options = {
  profile: @profile,
  region: @region
}

@ec2_list = Ec2List.new options

if @key
  @ec2_list.values(@key.to_sym).each do |v|
    puts v
  end
else
  Formatador.display_compact_table @ec2_list.result, [:id, :type, :tag, :fqdn, :ip_addr, :launched_at]
end
