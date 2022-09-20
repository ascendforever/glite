
__all__ = [
    'clean_time',
    'clean_time_long',
    'fmttimeit',
]

import timeit as timeit

from glite.__common import *

# noinspection PyShadowingNames
# noinspection PyUnusedLocal
def clean_time(time:float) -> str:
    """Clean text version of time in seconds; Does not go above `minutes`"""
# noinspection PyShadowingNames
# noinspection PyUnusedLocal
def clean_time_long(time:float) -> str:
    """Clean text version of time in seconds; Does not go above `years`"""
# noinspection PyShadowingBuiltins
# noinspection PyUnusedLocal
def fmttimeit(stmt:str="pass", setup:str="pass", timer=timeit.default_timer, number:int=timeit.default_number, globals=None) -> str:
    """Easy timing formatted"""
