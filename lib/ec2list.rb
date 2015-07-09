require "ec2list/version"
require "ec2list/cli"
require 'aws-sdk'
require 'formatador'

module Ec2list
  class Instances
    def initialize(opts)
      @profile = opts[:profile]
      @status = opts[:status]
      @tag = opts[:tag]
      Aws.config[:region] = opts[:region]
      Aws.config[:credentials] = Aws::SharedCredentials.new(profile_name: @profile)
    end

    def ec2
      @ec2 ||= Aws::EC2::Client.new
    end

    def result
      if @tag
        instance_list.select { |instance| instance[:tag].include?(@tag) }
      else
        instance_list
      end
    end

    def instance_list
      instances.map { |instance|
        {
          id: instance.instance_id,
          type: instance.instance_type,
          status: instance.state.name,
          since: since_about(Time.now - instance.launch_time),
          tag: instance.tags.find { |tag| tag.key == 'Name' }.value.gsub(' ', '_'),
          fqdn: instance.public_dns_name,
          ip_addr: instance.public_ip_address
        }
      }.sort_by { |x| x[:tag] }
    end
    
    def values(keys)
      result.map { |x| keys.map { |k| x[k] }.join (' ') }.compact.sort
    end

    def reservations
      ec2.describe_instances(filters: [filter]).reservations
    end
    
    def instances
      ec2.describe_instances(filters: [filter]).reservations.map { |x| x.instances }.flatten
    end

    def filter
      if @status
        {
          name: 'instance-state-name',
          values: [@status]
        }
      else
        {}
      end
    end

    private

    def since_about(second)
      if second > 86400
        "#{second.quo(86400).to_i}d"
      elsif second > 3600
        "#{second.quo(3600).to_i}h"
      else
        "#{second.quo(60).to_i}m"
      end
    end
  end
end
