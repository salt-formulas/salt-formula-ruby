{% set source_url = 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz' %}
{% set ruby_version = '2.0.0-p247' %}

remove_old_ruby_packages:
  pkg:
  - removed
  - names:
    - rake
    - rubygems
    - ruby-bundler
    - ruby1.8-full
    - ruby1.9.1-full

download_ruby_package:
  cmd.run:
  - name: wget {{ source_url }}
  - unless: "[ -f /root/ruby-{{ ruby_version }}.tar.gz ]"
  - cwd: /root
  - require:
    - pkg: remove_old_ruby_packages

untar_ruby_package:
  cmd.run:
  - name: tar -xzf ruby-{{ ruby_version }}.tar.gz
  - unless: "[ -d /root/ruby-{{ ruby_version }} ]"
  - cwd: /root
  - require:
    - cmd: download_ruby_package

compile_ruby_package:
  cmd.run:
  - name: ./configure && make && make install
#  - unless: "[ -d /root/ruby-{{ ruby_version }} ]"
  - cwd: /root/ruby-{{ ruby_version }}
  - require:
    - cmd: untar_ruby_package

install_ruby_bundler:
  cmd.run:
  - name: gem install bundler
#  - unless: "[ -d /root/ruby-{{ ruby_version }} ]"
  - require:
    - cmd: compile_ruby_package

ruby:
  grains.present:
    - value: 2.0
  require:
    - cmd: install_ruby_bundler
    - cmd: compile_ruby_package