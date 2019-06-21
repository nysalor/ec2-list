# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2list/version'

Gem::Specification.new do |spec|
  spec.name          = "ec2-list"
  spec.version       = Ec2list::VERSION
  spec.authors       = ["Jun Yokoyama"]
  spec.email         = ["jun@larus.org"]

  spec.summary       = %q{display list of ec2 instances.}
  spec.description   = %q{display list of ec2 instances. inspired by ec2list gem.}
  spec.homepage      = "https://github.com/nysalor/ec2-list"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sorbet"
  spec.add_development_dependency "sorbet-runtime"
  spec.add_dependency "thor"
  spec.add_dependency "aws-sdk"
  spec.add_dependency "formatador"
end
