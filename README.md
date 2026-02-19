# Bootstrap Ruby Gem [![Build Status](https://img.shields.io/travis/twbs/bootstrap-rubygem/master.svg)](https://travis-ci.org/twbs/bootstrap-rubygem) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 4](https://getbootstrap.com/) ruby gem for Ruby on Rails (Sprockets) and Hanami (formerly Lotus).

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

## Installation

Please see the appropriate guide for your environment of choice:

| Framework | Guide |
| --------- | ----- |
| Ruby on Rails 4+ | [Rails Setup](#a-ruby-on-rails) or other Sprockets environment |
| Other Ruby frameworks | [Other Ruby Setup](#b-other-ruby-frameworks) not on Rails |

### a. Ruby on Rails

Add `bootstrap` to your Gemfile:

```ruby
gem 'bootstrap', '~> 4.1.1'
```

Ensure that `sprockets-rails` is at least v2.3.2.

`bundle install` and restart your server to make the files available through the pipeline.

