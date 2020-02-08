""" the PYTHONSTARTUP file
"""
import atexit
import readline
import os
import sys
import math
import site
from pprint import pprint


_histfile_ = os.path.join(os.path.expanduser('~'), ".cache/python_history")
atexit.register(readline.write_history_file, _histfile_)
try:
    readline.read_history_file(_histfile_)
    readline.set_history_length(4000)
except FileNotFoundError:
    pass

# Aliases
pp = pprint
h = help
d = lambda obj: [d for d in dir(obj) if d[0] != '_']
