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
      instances.map { |instance|
        display_columns.zip(display_columns.map { |col| instance.send(col) }).to_h
      }
    end

    def display_columns
      %i(id type tag status fqdn ip_addr private_addr since)
    end

    def instance_list
      instances.sort_by(&:tag)
    end

    def values(keys)
      result.map { |x| keys.map { |k| x[k] }.join (' ') }.compact.sort
    end

    def reservations
      ec2.describe_instances(filters: [filter]).reservations
    end

    def instances
      if @tag
        all_instances.select { |instance| instance.cont?(@tag) }
      else
       all_instances
      end
    end

    def all_instances
      reservations.map { |x| x.instances }.flatten.map { |ec2| Instance.new ec2 }
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
  end

  class Instance
    attr_accessor :id, :type, :status, :since, :tags, :fqdn, :ip_addr, :private_addr

    def initialize(ec2)
      @id = ec2.instance_id
      @type = ec2.instance_type
      @status = ec2.state.name
      @since = since_about(Time.now - ec2.launch_time)
      @tags = ec2.tags || []
      @fqdn = ec2.public_dns_name
      @ip_addr = ec2.public_ip_address
      @private_addr = ec2.private_ip_address
    end

    def name
      name_tag = tags.find { |tag| tag.key == 'Name' }
      if name_tag
        name_tag.value.gsub(' ', '_')
      else
        nil
      end
    end

    def tag
      name
    end

    def cont?(tag)
      name && name.include?(tag)
    end

    private

    def since_about(since)
      if since > 86400
        "#{since.quo(86400).to_i}d"
      elsif since > 3600
        "#{since.quo(3600).to_i}h"
      else
        "#{since.quo(60).to_i}m"
      end
    end
  end
end
