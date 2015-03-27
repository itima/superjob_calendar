# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'superjob_calendar/version'

Gem::Specification.new do |spec|
  spec.name          = "superjob_calendar"
  spec.version       = SuperjobCalendar::VERSION
  spec.authors       = ["Alexey Nureev"]
  spec.email         = ["alexey.nureev@gmail.com"]
  spec.summary       = %q{Business calendar with superjob sync.}
  spec.description   = %q{Business calendar with superjob sync.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "business_time", '~> 0.7.3'
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
