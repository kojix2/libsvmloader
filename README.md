# LibSVMLoader

[![Build Status](https://travis-ci.org/yoshoku/LibSVMLoader.svg?branch=master)](https://travis-ci.org/yoshoku/LibSVMLoader)
[![Coverage Status](https://coveralls.io/repos/github/yoshoku/LibSVMLoader/badge.svg?branch=master)](https://coveralls.io/github/yoshoku/LibSVMLoader?branch=master)
[![Gem Version](https://badge.fury.io/rb/libsvmloader.svg)](https://badge.fury.io/rb/libsvmloader)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/yoshoku/LibSVMLoader/blob/master/LICENSE.txt)

LibSVMLoader loads (and dumps) dataset file with the libsvm file format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'libsvmloader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libsvmloader

## Usage

```ruby
require 'libsvmloader'

# for classification task
samples, labels = LibSVMLoader.load_libsvm_file('foo.t')
LibSVMLoader.dump_libsvm_file(samples, labels, 'bar.t')

# for regression task
samples, target_variables = LibSVMLoader.load_libsvm_file('foo.t', label_dtype: 'float')
LibSVMLoader.dump_libsvm_file(samples, target_variables, 'bar.t')
```

When using with Numo::NArray:

```ruby
require 'libsvmloader'
require 'numo/narray'

samples, labels = LibSVMLoader.load_libsvm_file('foo.t')

samples_na = Numo::NArray[*samples]
labels_na = Numo::NArray[*labels]

LibSVMLoader.dump_libsvm_file(samples_na.to_a, labels_na.to_a, 'bar.t')
```

When using with NMatrix:

```ruby
require 'libsvmloader'
require 'nmatrix/nmatrix'

samples, labels = LibSVMLoader.load_libsvm_file('foo.t')

samples_nm = N[*samples]
labels_nm = N[*labels]

LibSVMLoader.dump_libsvm_file(samples_nm.to_a, labels_nm.to_a, 'bar.t')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/libsvmloader.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
