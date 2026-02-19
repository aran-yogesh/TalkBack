# Bootstrap Ruby Gem [![Build Status](https://img.shields.io/travis/twbs/bootstrap-rubygem/main.svg)](https://travis-ci.org/twbs/bootstrap-rubygem) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 4](https://getbootstrap.com/) ruby gem for Ruby on Rails (Sprockets) and Hanami (formerly Lotus).

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

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

## Table of Contents

1. [Installation and Usage](#installation-and-usage)
2. [Configuration](#configuration)
3. [Code of Conduct](#code-of-conduct)
4. [Filing Issues](#filing-issues)
5. [Frequently Asked Questions](#frequently-asked-questions)
6. [Releases](#releases)
7. [Semantic Versioning Policy](#semantic-versioning-policy)
8. [License](#license)
9. [Team](#team)
10. [Sponsors](#sponsors)
11. [Technology Sponsors](#technology-sponsors)

## Installation and Usage

Prerequisites: [Node.js](https://nodejs.org/en/) (`^8.10.0`, `^10.13.0`, or `>=11.10.1`), npm version 3+.

You can install ESLint using npm:

```
$ npm install eslint --save-dev
```

