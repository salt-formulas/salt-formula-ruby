{% from 'ruby/params.sls' import ruby_params with context %}

clean_ruby_packages:
  pkg:
  - removed
  - names:
    {%- for package in ruby_params['obsolete_packages'] %}
    - {{ package }}
    {%- endfor %}

{% if ruby_params.build_from_source %}

download_ruby_package:
  cmd.run:
  - name: wget {{ ruby_params.base_url }}
  - unless: "[ -f /root/{{ ruby_params.base_file }} ]"
  - cwd: /root
  - require:
    - pkg: clean_ruby_packages

untar_ruby_package:
  cmd.run:
  - name: tar -xzf {{ ruby_params.base_file }} 
  - unless: "[ -d /root/ruby-{{ ruby_params.version }} ]"
  - cwd: /root
  - require:
    - cmd: download_ruby_package

compile_ruby_package:
  cmd.run:
  - name: ./configure && make && make install
#  - unless: "[ -d /root/ruby-{{ ruby_params.version }} ]"
  - cwd: /root/ruby-{{ ruby_params.version }}
  - require:
    - cmd: untar_ruby_package

install_ruby_bundler:
  cmd.run:
  - name: gem install bundler
#  - unless: "[ -d /root/ruby-{{ ruby_params.version }} ]"
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