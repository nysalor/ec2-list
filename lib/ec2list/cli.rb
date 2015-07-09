require 'thor'

module Ec2list
  class CLI < Thor
    default_command :display

    option :p, type: :string, default: 'default'
    option :r, type: :string, default: 'ap-northeast-1'
    option :k, type: :string
    option :s, type: :string
    option :t, type: :string
    
    desc "display", "display instances list"
    def display
      if options[:key]
        ec2_list.values(options[:key].to_sym).each do |v|
          puts v
        end
      else
        Formatador.display_compact_table ec2_list.result, [:id, :type, :tag, :status, :fqdn, :ip_addr, :since]
      end
    end

    private

    def ec2_list
      @ec2_list ||= Ec2list::Instances.new(option_strings)
    end

    def option_strings
      {
        profile: options[:p],
        region: options[:r],
        status: options[:s],
        tag: options[:t]
      }
    end
  end
end
