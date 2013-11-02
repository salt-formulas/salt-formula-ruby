{% set source_url = 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz' %}
{% set ruby_version = '1.9.3-p448' %}

ruby_ppa:
  pkgrepo.managed:
  - ppa: brightbox/ruby-ng

ruby_packages:
  pkg:
  - installed
  - names:
    - rake
    - rubygems
    - ruby-bundler
    - ruby1.9.3
  - require:
    - pkgrepo: ruby_ppa

ruby:
  grains.present:
    - value: 1.9
  require:
    - cmd: ruby_packages