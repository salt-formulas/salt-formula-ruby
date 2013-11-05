
{% set os = salt['grains.item']('os')['os'] %}

{% set os_family = salt['grains.item']('os_family')['os_family'] %}

{% if pillar.ruby.version is defined %}
{% set ruby_params['version'] = pillar.ruby.version %}
{% else %}
{% set ruby_params['version'] = '2.0' %}
{% endif %}

{% if ruby_params['version'] == '1.8' %}
{{ ruby_params['release'] = '1.8.7-p374' }}
{{ ruby_params['obsolete_packages'] = ['ruby1.9.1-full'] }}
{{ ruby_params['build_from_source'] = false }}
{% elif ruby_version == '1.9' %
{{ ruby_params['release'] = '1.9.3-p448' }}
{{ ruby_params['build_from_source'] = false }}
{{ ruby_params['obsolete_packages'] = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full'] }}
{% elif ruby_version == '2.0' %}
{{ ruby_params['release'] = '2.0.0-p247' }}
{{ ruby_params['build_from_source'] = true }}
{{ ruby_params['obsolete_packages'] = ['rake', 'rubygems', 'ruby-bundler', 'ruby1.8-full', 'ruby1.9.1-full'] }}
{% endif %}

{% set base_url_fragments = [ 'http://ftp.ruby-lang.org/pub/ruby/', ruby_params['version'], '/' ] %}
{% set ruby_params['base_url'] = base_url_fragments|join('') %}

{% set base_file_fragments = [ 'ruby-', ruby_params['release'], '.tar.gz' ] %}
{% set ruby_params['base_file'] = base_file_fragments|join('') %}
