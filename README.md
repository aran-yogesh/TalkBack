# Bootstrap Ruby Gem [![Build Status](https://img.shields.io/travis/twbs/bootstrap-rubygem/master.svg)](https://travis-ci.org/twbs/bootstrap-rubygem) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 4](https://getbootstrap.com/) ruby gem for Ruby on Rails (Sprockets) and Hanami (formerly Lotus).

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

## Table of Contents

- [Installation](#installation)
  - [a. Ruby on Rails](#a-ruby-on-rails)
  - [b. Other Ruby frameworks](#b-other-ruby-frameworks)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Installation

Please see the appropriate guide for your environment of choice:

* [Ruby on Rails 4+](#a-ruby-on-rails) or other Sprockets environment.
* [Other Ruby frameworks](#b-other-ruby-frameworks) not on Rails.

### a. Ruby on Rails

Add `bootstrap` to your Gemfile:

```ruby
gem 'bootstrap', '~> 4.1.1'
```

Ensure that `sprockets-rails` is at least v2.3.2.

`bundle install` and restart your server to make the files available through the pipeline.

### b. Other Ruby frameworks

If your framework uses Sprockets or Hanami, the assets will be registered with Sprockets when the gem is required, and you can use them as per the Rails section of the guide.

Otherwise you may need to register the assets manually. Refer to your framework's documentation on the subject.

## Configuration

By default all of Bootstrap is imported.

You can also import components explicitly. To start with a full list of modules copy `_bootstrap.scss` file into your assets as `_bootstrap-custom.scss`. Then comment out components you do not want from `_bootstrap-custom`. In the application Sass file, replace `@import 'bootstrap'` with:

```scss
@import 'bootstrap-custom';
```

## Contributing

Contributions are welcome! Please refer to the [contributing guidelines](CONTRIBUTING.md) for details.

## License

MIT License. See [LICENSE](LICENSE) for details.
