{% from 'ruby/params.sls' import params with context %}

clean_ruby_packages:
  pkg:
  - removed
  - names: {{ params.obsolete_packages|json }}

{% if params.build_from_source %}

download_ruby_package:
  cmd.run:
  - name: wget {{ params.base_url }}
  - unless: "[ -f /root/{{ params.base_file }} ]"
  - cwd: /root
  - require:
    - pkg: clean_ruby_packages

untar_ruby_package:
  cmd.run:
  - name: tar -xzf {{ params.base_file }} 
  - unless: "[ -d /root/ruby-{{ params.version }} ]"
  - cwd: /root
  - require:
    - cmd: download_ruby_package

compile_ruby_package:
  cmd.run:
  - name: ./configure && make && make install
#  - unless: "[ -d /root/ruby-{{ params.version }} ]"
  - cwd: /root/ruby-{{ params.version }}
  - require:
    - cmd: untar_ruby_package

install_ruby_bundler:
  cmd.run:
  - name: gem install bundler
#  - unless: "[ -d /root/ruby-{{ params.version }} ]"
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