
=========================
Ruby programming language
=========================

Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write. 

Pillars
=======

Ruby version 1.8

.. code-block:: yaml

    ruby:
      enabled: true
      version: '1.8'
      development: true

Ruby version 1.9

.. code-block:: yaml

    ruby:
      enabled: true
      version: '1.9'
      development: true

Ruby version 2.1

.. code-block:: yaml

    ruby:
      enabled: true
      version: '2.1'
      development: true

Example gem deployment of Sensu plugin

.. code-block:: yaml

    environment:
      managed: False
      gem:
        sensu-plugins-elasticsearch:
          version: 0.4.3
          user: sensu
          executable: /opt/sensu/embedded/bin/gem

Read more
=========

* https://www.ruby-lang.org/en/
