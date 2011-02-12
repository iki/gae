Google App Engine Python SDK for Linux/Mac/Windows
**************************************************

.. contents::


Overview
========

Summary
-------

  Google App Engine (GAE_) Python SDK_ packaged for simple inclusion within your project.

  .. _GAE:
  .. _Google App Engine: http://code.google.com/appengine/
  .. _SDK: http://code.google.com/appengine/docs/python/overview.html


Use cases
---------

  * Clone the repository to gain simple SDK updating (``git pull``)
    and switching::

      git checkout --track origin/1.4.1   # get info on branch 1.4.1 and switch to
      git checkout master                 # switch to the newest version
      git checkout 1.4.1                  # switch to 1.4.1

  * Fork the repository and add it as a git submodule_ of your project,
    so all developers can instantly have the same SDK version
    and operational commands across supported platforms.

    .. _submodule: http://progit.org/book/ch6-6.html

  * Control which SDK is used for each project
    via environment variable or configuration file.

  * Control which version of Python runtime is used for each project
    via environment variable or configuration file.

    - Get the required runtime automatically installed on Debian/Ubuntu-based
      distros if needed.
    - Get the recommended `Python 2.5`_ runtime automatically installed
      on Ubuntu Lucid/Maverick using `Felix Krull PPA`_ repository.

      .. _Python 2.5: http://python.org/download/releases/2.5/
      .. _Felix Krull PPA: https://launchpad.net/~fkrull/+archive/deadsnakes


Getting started
---------------

 1. Clone the repository_.
    Or fork it and add as a git submodule to your project.

      .. _repository: https://github.com/iki/gae/

 2. Copy the `configuration file`_ (``gae.conf``),
    `helpers`_ (``gae``, ``gae.bat``, ``gae.py``)
    and selected `commands`_ (``gae-*``)
    to your project directory.

 3. Set GAE_SDK_ path in the configuration file.



Structure
---------

  * The `sdk <sdk>`__ directory contains the SDK_
    from an original cross-platform `zip archive`__.

    __ http://code.google.com/appengine/downloads.html#Google_App_Engine_SDK_for_Python

  * Additionally, the `sdk/launcher <sdk/launcher>`__ directory
    contains the Windows Launcher GUI from an original `msi installer`__.

    __ http://code.google.com/appengine/downloads.html#Google_App_Engine_SDK_for_Python
 
    - *Note: if you know how to add a Mac Launcher GUI, 
      just fork, add it and send me a pull request.*
      
  * Additionally, the `sdk/docs <sdk/docs>`__ directory
    contains the documentation from an original `zip archive`__.

    __ http://code.google.com/appengine/downloads.html#Download_the_Google_App_Engine_Documentation

  * The `tools`_ outside ``sdk`` directory
    are provided for simple use of the SDK
    and do not originate from `Google App Engine`_ project.


License
-------

  * The ``sdk`` directory contains the SDK_ and documentation.
    You can find the license terms in `sdk/license <sdk/license>`__.

  * The `tools`_ outside ``sdk`` directory are licensed under
    `Apache License, Version 2.0`__.

    __ http://www.apache.org/licenses/LICENSE-2.0




Tools
=====

  Provided for simple use of the SDK across supported platforms.
  They ensure that the configured SDK and Python version are used.


Commands
--------

  Shortcuts for running SDK commands using the configured SDK and Python version.

  Provided as a shell scripts for Linux/Mac and a batch scripts (``*.bat``) for Windows.

  ``gae-app``
    ``Deploys and maintains the application in App Engine cloud.``

  ``gae-server``
    ``Runs development server.``

  ``gae-launcher``                                                        
    ``Runs a Launcher GUI to control development server and deployments.  [windows-only]``

  ``gae-rsh``
    ``Connects Python shell to an application via enabled Remote API.``

  ``gae-bulkloader``
    ``Pushes data to an application via enabled Remote API.``

  ``gae-docs``
    ``Opens GAE Python SDK documentation on Google site.``

  ``gae-docs-local``
    ``Opens local copy of GAE Python SDK documentation.``

  ``gae-py``
    ``Runs the python version specified in a configuration file (defaults to 2.5).``


Helpers
-------

Command helpers
...............

  Used by most of the commands_ above.
  They load the configuration and optionally run an SDK command.

  Linux/Mac `gae <gae>`__ shell script and library::

    . gae && gae_configure <config_file>
    gae [-v|--verbose] <command> [options] [arguments]
    gae --help

  Windows `gae.bat <gae.bat>`__ script::

    gae [-v|--verbose] <command> [options] [arguments]
    gae --help

Python helper module
....................

  The python module `gae.py <gae.py>`__
  allows simple SDK acces from any python script or module.
  It loads the configuration and inserts GAE into ``sys.path``.

  Example::

    import gae
    gae.initialize()

    print gae.settings.GAE_SDK
    import sys; print '\n'.join(sys.path)

    from google.appengine.ext import db, blobstore

  This module is **not needed** for the GAE application itself,
  because the environment is already set up by the development server.


Configuration file
------------------

  The configuration file `gae.conf <gae.conf>`__ defines environment
  for the commands and helpers located in the same directory.
  Users can overload the settings via environment variables.

  It may contain arbitrary configuration variables.
  The following ones are used by most commands:

  .. _GAE_SDK:

  **GAE_SDK** ``[required]``
    Directory of the SDK to be used. 
    If it starts with ``./``, it is treated as relative to this configuration file.

  **GAE_PYV**
    Python version to use.
    Defaults to **2.5**. Using a newer version is not recommended now.

  **GAE_PYW**
     Directory of python.exe to be used with SDK on Windows.
     If not set, common locations are searched for requested Python version.
