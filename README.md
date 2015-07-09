# Ec2list

command line AWS EC2 instance list viewer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ec2-list'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ec2-list

## Usage

    $ ec2-list
	
## Options

```
-p [PROFILE_NAME] (default)
-r [REGION] (ap-northeast-1)
-k [KEY]
-s [STATUS]
-t [TAG]
```

## Example

    $ ec2-list -p myaws -r ap-northeast-1 -k fqdn -s running -t production

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nysalor/ec2-list.
