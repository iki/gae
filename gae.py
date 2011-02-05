#!/bin/env python
""" Provides GAE variables from environment and configuration file
    ==============================================================

    * The configuration file should be located in the same directory as this script,
      and bave the same file name and a .conf extension (ie. gae.conf).
"""
from __future__ import with_statement # for python 2.5

import sys, os, re, string, logging


""" Settings
    --------
"""
BASENAME = os.path.splitext(os.path.abspath(os.path.realpath(__file__)))[0]
BASEDIR  = os.path.dirname(BASENAME)
CONFNAME = '%s.conf' % BASENAME
ENV_MASK = re.compile('GAE_.*')
INITLOG  = logging.getLogger('gae.init')

class Settings(dict):
    template  = '%%-%ds = %%s\n'
    separator = ''

    def __getattr__(self, k):
        try:
            return self.__getitem__(k)
        except KeyError:
            raise AttributeError(k)

    def __str__(self):
         t = self.template % max(map(len, self))
         return self.separator.join( t % (k, self[k]) for k in sorted(self) )

settings = Settings()

defaults = Settings(
    GAE_PYV = '2.5',
    )

coercers = Settings(
    GAE_SDK = lambda p: p and (os.path.isabs(p) and p or os.path.normpath(os.path.join(BASEDIR, p))) or p,
    )

validators = Settings(
    GAE_SDK = lambda p: p and os.path.exists(os.path.join(p, 'appcfg.py')),
    )

def initialize(gae_sys_path=True, **argd):
    """ Updates settings dictionary and sys.path
    """ 
    settings.update(init_settings(**argd))

    if gae_sys_path:

         sys.path[0:0] = [ settings.GAE_SDK ]

         from appcfg import fix_sys_path

         sys.path[0:0] = []

         fix_sys_path()



""" Helper functions
    ----------------
"""
def init_settings(conf=CONFNAME, comment='#', sep='=', env_mask=ENV_MASK, env=os.environ,
    defaults=defaults, validators=validators, coercers=coercers, log=INITLOG):
    """ Returns a dictionary of settings as read from environment, a configfile, or defaults.
    """ 
    s = defaults.copy()

    coerce_settings(s, coercers)
    test_settings(s, validators, fail=False, skip_missing=True, log=log)

    s.update(load_settings(conf, comment, sep))
    s.update( (k, v) for k, v in env.items() if env_mask.match(k) )

    coerce_settings(s, coercers)
    test_settings(s, validators, log=log)

    return s

def coerce_settings(settings, coercers=coercers):
    """ Coerce a dictionary of settings via dictionary of coercer functions.
    """ 
    for k, v in coercers.items():
        if k in settings:
             settings[k] = v(settings[k])

def test_settings(settings, validators=validators, fail=True, skip_missing=False, log=INITLOG):
    """ Test a dictionary of settings via dictionary of validator functions.
    """ 
    for k, v in validators.items():
        if k in settings:
            if not v(settings[k]):
                log.error('Invalid %s: %r' % (k, settings[k]))
                if fail: raise ValueError('Invalid %s: %r' % (k, settings[k]))
        elif not skip_missing:
            log.error('Undefined %s' % k)
            if fail: raise ValueError('Undefined %s' % k)

def load_settings(conf=CONFNAME, comment='#', sep='='): 
    """ Returns a dictionary of settings as read from a configfile
    """ 
    if isinstance(conf, basestring):
        with file(conf, 'r') as conf:
            return load_settings(conf, comment, sep)
	
    return dict( map(string.strip, line.split(sep, 1)) for line in conf
         if not line.startswith(comment) and line.find(sep) != -1 )



""" Execution from command-line
    ---------------------------
"""
if __name__ == '__main__':

    initialize()
    sys.stdout.write(str(settings))

    # from google.appengine.ext import db, blobstore
