
{% set os = salt['grains.item']('os')['os'] %}

{% set os_family = salt['grains.item']('os_family')['os_family'] %}

{% if pillar.ruby.version is defined %}
{% set version = pillar.ruby.version %}
{% else %}
{% set version = '2.0' %}
{% endif %}

{% if version == '1.8' %}
{% set release = '1.8.7-p374' %}
{% set checksum = 'md5=c351450a0bed670e0f5ca07da3458a5b' %}
{% set obsolete_packages = ['ruby1.9.1-full'] %}
{% set build_from_source = false %}
{% elif version == '1.9' %}
{% set release = '1.9.3-p448' %}
{% set checksum = 'md5=c351450a0bed670e0f5ca07da3458a5b' %}
{% set build_from_source = false %}
{% set obsolete_packages = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full'] %}
{% elif version == '2.0' %}
{% set release = '2.0.0-p353' %}
{% set checksum = 'md5=78282433fb697dd3613613ff55d734c1' %}
{% set build_from_source = true %}
{% set obsolete_packages = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full', 'ruby1.9.1-full'] %}
{% endif %}

{% set base_url_fragments = [ 'http://ftp.ruby-lang.org/pub/ruby/', version ] %}
{% set base_url = base_url_fragments|join('') %}

{% set base_file_fragments = [ 'ruby-', release, '.tar.gz' ] %}
{% set base_file = base_file_fragments|join('') %}

ruby_clean_packages:
  pkg:
  - purged
  - names:
    {%- for package in obsolete_packages %}
    - {{ package }}
    {%- endfor %}

{% if build_from_source %}

ruby_dependencies:
  pkg.installed:
  - names:
    - build-essential
    - zlib1g-dev
    - libssl-dev
    - libreadline6-dev
    - libyaml-dev 

ruby_download:
  file.managed:
  - name: /root/{{ base_file }}
  - source: {{ base_url }}/{{ base_file }}
  - source_hash: {{ checksum }}
  - require:
    - pkg: ruby_dependencies
    - pkg: ruby_clean_packages

ruby_unpack:
  cmd.run:
  - cwd: /root
  - unless: "[ -d /root/ruby-{{ release }} ]"
  - names:
    - tar -zxvf /root/{{ base_file }}
  - require:
    - file: ruby_download

ruby_make:
  cmd.wait:
    - names:
      - ./configure --prefix=/usr/local
      - make
      - make install
    - cwd: /root/ruby-{{ release }}
    - watch:
      - cmd: ruby_unpack

ruby_bundler_gem:
  cmd.wait:
  - name: gem install bundler
  - watch:
    - cmd: ruby_make

{% else %}

ruby_repo:
  pkgrepo.managed:
  - ppa: brightbox/ruby-ng
  - require:
    - pkg: ruby_clean_packages

ruby_packages:
  pkg:
  - installed
  - require:
    - pkgrepo: ruby_repo
  - names:
    {% if version == "1.9" %}
    - ruby1.9.3
    - ruby1.9.1-dev
    {% endif %}
    - rake
    - rubygems
    - ruby-bundler

{% endif %}