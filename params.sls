
{% set os = salt['grains.item']('os')['os'] %}

{% set os_family = salt['grains.item']('os_family')['os_family'] %}

{% if pillar.ruby.version is defined %}
{% set params['version'] = pillar.ruby.version %}
{% else %}
{% set params['version'] = '2.0' %}
{% endif %}

{% if params['version'] == '1.8' %}
{{ params['release'] = '1.8.7-p374' }}
{{ params['obsolete_packages'] = ['ruby1.9.1-full'] }}
{{ params['build_from_source'] = false }}
{% elif ruby_version == '1.9' %
{{ params['release'] = '1.9.3-p448' }}
{{ params['build_from_source'] = false }}
{{ params['obsolete_packages'] = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full'] }}
{% elif ruby_version == '2.0' %}
{{ params['release'] = '2.0.0-p247' }}
{{ params['build_from_source'] = true }}
{{ params['obsolete_packages'] = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full', 'ruby1.9.1-full'] }}
{% endif %}

{% set base_url_fragments = [ 'http://ftp.ruby-lang.org/pub/ruby/', params['version'], '/' ] %}
{% set params['base_url'] = base_url_fragments|join('') %}

{% set base_file_fragments = [ 'ruby-', params['release'], '.tar.gz' ] %}
{% set params['base_file'] = base_file_fragments|join('') %}
