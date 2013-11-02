{#TODO remove old package #}
{#{% if pillar.ruby.version != grains.get('ruby') %}
remove_old_ruby_packages:
  pkg:
  - removed
  - names:
    - rake
    - rubygems
    - ruby-bundler
    - ruby1.8-full
{% endif %}
#}
include:
{%- if pillar.ruby.enabled and pillar.ruby.version == '2.0'  %}
- ruby.2_0
{%- elif pillar.ruby.enabled and pillar.ruby.version == '1.9' %}
- ruby.1_9
{%- elif pillar.ruby.enabled and pillar.ruby.version == '1.8' %}
- ruby.1_8
{%- endif %}