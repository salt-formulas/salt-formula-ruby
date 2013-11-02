{% set os = salt['grains.item']('os')['os'] %}

{% set os_family = salt['grains.item']('os_family')['os_family'] %}

{%- if pillar.ruby.enabled %}

{% if pillar.ruby.version == "2.0" %}

{% set source_url = 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz' %}
{% set ruby_version = '2.0.0-p247' %}

{%- elif pillar.ruby.version == "1.9" %}

{% set source_url = 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz' %}
{% set ruby_version = '1.9.3-p448' %}

{%- elif pillar.ruby.version == "1.8" %}

{% set source_url = 'http://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz' %}
{% set ruby_version = '1.8.7-p374' %}

{%- endif %}