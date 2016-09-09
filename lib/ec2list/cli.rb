require 'thor'

module Ec2list
  class CLI < Thor
    default_command :display

    option :p, type: :string, default: 'default'
    option :r, type: :string, default: 'ap-northeast-1'
    option :k, type: :string
    option :s, type: :string
    option :t, type: :string
    option :l, type: :boolean, default: false
    
    desc "display", "display instances list"
    def display
      if options[:k]
        ec2_list.values(options[:k].split(',').map(&:to_sym)).each do |v|
          puts v if v.length > 0
        end
      elsif options[:l]
        ec2_list.result.each do |instance|
          puts display_columns.map { |column| instance[column] }.join(' ')
        end
      else
        Formatador.display_compact_table ec2_list.result, display_columns
      end
    end

    private

    def display_columns
      ec2_list.display_columns
    end

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
