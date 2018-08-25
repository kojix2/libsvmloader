# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libsvmloader/version'

Gem::Specification.new do |spec|
  spec.name          = 'libsvmloader'
  spec.version       = LibSVMLoader::VERSION
  spec.authors       = ['yoshoku']
  spec.email         = ['yoshoku@outlook.com']

  spec.summary       = <<MSG
LibSVMLoader loads (and dumps) dataset file with the libsvm file format.
MSG
  spec.description   = <<MSG
LibSVMLoader is a class that loads (and dumps) dataset file with the libsvm file format.
The feature vectors and labels of dataset are represented by Ruby Array.
MSG
  spec.homepage      = 'https://github.com/yoshoku/libsvmloader'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
