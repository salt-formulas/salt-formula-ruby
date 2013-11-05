
{% set os = salt['grains.item']('os')['os'] %}

{% set os_family = salt['grains.item']('os_family')['os_family'] %}

{% if pillar.ruby.version is defined %}
{% set version = pillar.ruby.version %}
{% else %}
{% set version = '2.0' %}
{% endif %}

{% if version == '1.8' %}
{{ release = '1.8.7-p374' }}
{{ obsolete_packages = ['ruby1.9.1-full'] }}
{{ build_from_source = false }}
{% elif ruby_version == '1.9' %
{{ release = '1.9.3-p448' }}
{{ build_from_source = false }}
{{ obsolete_packages = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full'] }}
{% elif ruby_version == '2.0' %}
{{ release = '2.0.0-p247' }}
{{ build_from_source = true }}
{{ obsolete_packages = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full', 'ruby1.9.1-full'] }}
{% endif %}

{% set base_url_fragments = [ 'http://ftp.ruby-lang.org/pub/ruby/', version, '/' ] %}
{% set base_url = base_url_fragments|join('') %}

{% set base_file_fragments = [ 'ruby-', release, '.tar.gz' ] %}
{% set base_file = base_file_fragments|join('') %}

clean_ruby_packages:
  pkg:
  - removed
  - names:
    {%- for package in obsolete_packages %}
    - {{ package }}
    {%- endfor %}

{% if build_from_source %}

download_ruby_package:
  cmd.run:
  - name: wget {{ base_url }}
  - unless: "[ -f /root/{{ base_file }} ]"
  - cwd: /root
  - require:
    - pkg: clean_ruby_packages

untar_ruby_package:
  cmd.run:
  - name: tar -xzf {{ base_file }} 
  - unless: "[ -d /root/ruby-{{ version }} ]"
  - cwd: /root
  - require:
    - cmd: download_ruby_package

compile_ruby_package:
  cmd.run:
  - name: ./configure && make && make install
#  - unless: "[ -d /root/ruby-{{ version }} ]"
  - cwd: /root/ruby-{{ version }}
  - require:
    - cmd: untar_ruby_package

install_ruby_bundler:
  cmd.run:
  - name: gem install bundler
#  - unless: "[ -d /root/ruby-{{ version }} ]"
  - require:
    - cmd: compile_ruby_package

{% else %}

{#

ruby_repo:
  pkgrepo.managed:
  - ppa: brightbox/ruby-ng
  - require:
    - pkg: clean_ruby_packages

ruby_packages:
  pkg:
  - installed
  - require:
    - pkgrepo: ruby_repo
  - names:
    - rake
    - rubygems
    - ruby-bundler
#}

{% endif %}