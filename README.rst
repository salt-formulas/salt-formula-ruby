
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

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-ruby/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-ruby

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
