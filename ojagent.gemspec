# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ojagent/version'

Gem::Specification.new do |gem|
  gem.name          = "ojagent"
  gem.version       = OJAgent::VERSION
  gem.authors       = ["Zejun Wu"]
  gem.email         = ["zejun.wu@gmail.com"]
  gem.description   = <<-EOF
OJAgent is a client to submit and query status at different online judges.
It provides a uniformed interface to a lot of famous online judges.
EOF
  gem.summary       = %q{Agent/Bot/Proxy for Online Judges.}
  gem.homepage      = "https://github.com/watashi/ojagent"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'mechanize', '~> 2.5.1'
  gem.add_dependency 'nokogiri',  '~> 1.5.5'
  gem.add_dependency 'slop',      '~> 3.3.3'
  gem.add_dependency 'highline',  '~> 1.6.15'
end
