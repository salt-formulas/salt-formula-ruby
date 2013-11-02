{% set source_url = 'http://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz' %}
{% set ruby_version = '1.8' %}
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
    - ruby{{ ruby_version }}-full
  - require:
    - pkgrepo: ruby_ppa

ruby:
  grains.present:
    - value: '1.8'
  require:
    - cmd: ruby_packages