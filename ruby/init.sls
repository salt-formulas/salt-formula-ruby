{%- from "ruby/map.jinja" import environment with context %}
{%- if environment.enabled %}

{% if environment.version is defined %}
{% set version = environment.version %}
{% else %}
{% set version = '2.1' %}
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
{% set obsolete_packages = ['ruby1.8-full'] %}
{% elif version == '2.0' %}
{% set release = '2.0.0-p353' %}
{% set checksum = 'md5=78282433fb697dd3613613ff55d734c1' %}
{% set build_from_source = true %}
{% set obsolete_packages = ['ruby1.8-full', 'ruby1.9.1-full'] %}
{% elif version == '2.1' %}
{% set release = '2.1.8' %}
{% set checksum = 'sha1=c7e50159357afd87b13dc5eaf4ac486a70011149' %}
{% set build_from_source = true %}
{% set obsolete_packages = ['ruby1.8-full', 'ruby1.9.1-full', 'ruby1.9.1'] %}
{% endif %}

{% set base_url_fragments = [ 'http://cache.ruby-lang.org/pub/ruby/', version ] %}
{% set base_url = base_url_fragments|join('') %}

{% set base_file_fragments = [ 'ruby-', release, '.tar.gz' ] %}
{% set base_file = base_file_fragments|join('') %}

{%- if environment.get('managed', True) %}

ruby_clean_packages:
  pkg:
  - purged
  - names:
    {%- for package in obsolete_packages %}
    - {{ package }}
    {%- endfor %}

{% if build_from_source %}

{%- if grains.os_family == 'Debian' %}

ruby_dependencies:
  pkg.installed:
  - names:
    - build-essential
    - libssl-dev
    - libyaml-dev
    - zlib1g-dev
    - libreadline6-dev

{%- endif %}  

ruby_download:
  file.managed:
  - name: /root/{{ base_file }}
  - source: {{ base_url }}/{{ base_file }}
  - source_hash: {{ checksum }}
  - require:
    - pkg: ruby_clean_packages

ruby_unpack:
  cmd.run:
  - cwd: /root
  - unless: "[ -d /root/ruby-{{ release }} ]"
  - names:
    - tar -zxvf /root/{{ base_file }}
  - require:
    - file: ruby_download

ruby_compile_configure:
  cmd.wait:
  - name: ./configure --prefix=/usr/local --disable-install-rdoc
  - cwd: /root/ruby-{{ release }}
  - watch:
    - cmd: ruby_unpack

ruby_compile_make:
  cmd.wait:
  - name: make
  - cwd: /root/ruby-{{ release }}
  - watch:
    - cmd: ruby_compile_configure

ruby_compile_make_install:
  cmd.wait:
  - name: make install
  - cwd: /root/ruby-{{ release }}
  - watch:
    - cmd: ruby_compile_make

ruby_bundler_gem:
  cmd.wait:
  - name: gem install bundler --no-ri --no-rdoc
  - watch:
    - cmd: ruby_compile_make_install

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
    {%- if version == "1.9" %}
    - ruby1.9.3
    - ruby1.9.1-dev
    {%- else %}
    - rake
    - ruby-bundler
    {%- endif %}

{%- endif %}

{%- endif %}

{%- for gem_name, gem in environment.gem.iteritems() %}

{{ gem.get('gem_bin', 'default') }}_{{ gem_name }}:
  gem.installed:
  - name: {{ gem_name }}
  {%- if gem.executable is defined %}
  - gem_bin: {{ gem.executable }}
  {%- endif %}
  {%- if gem.user is defined %}
  - user: {{ gem.user }}
  {%- endif %}
  {%- if gem.ruby is defined %}
  - ruby: {{ gem.ruby }}
  {%- endif %}
  {%- if gem.version is defined %}
  - version: {{ gem.version }}
  {%- endif %}

{%- endfor %}

{%- endif %}