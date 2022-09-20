
__all__ = [
    'clean_time',
    'clean_time_long',
    'fmttimeit',
]

from glite.__common import *
from glite.__static cimport *


cpdef str clean_time(const cython.longdouble time):
    cdef cython.uint min
    cdef cython.double sec
    min,sec = divmod(time, 60) # noqa shadowing
    if min==0: return f"{sec:.2f} seconds" # 2 decimals if we didnt go into minutes
    return f"{min} minutes and {sec:.1f} seconds"

cpdef str clean_time_long(const cython.longdouble time):
    cdef cython.uint min
    cdef cython.double sec
    min,sec = divmod(time, 60)
    if min ==0: return f"{sec:.2f} seconds" # 2 decimals if we didnt go into minutes
    cdef cython.uint hr
    hr,min   = divmod(int(min), 60) # yes we need that int conversion # I don't remember writing this comment so I will just leave it as is
    if hr  ==0: return f"{min} minute{'' if min==1 else 's'} and {sec:.1f} seconds"
    cdef cython.uint day
    day,hr   = divmod(hr,  24)
    if day ==0: return f"{hr} hour{'' if hr==1 else 's'}, {min} minute{'' if min==1 else 's'}, and {sec:.1f} seconds"
    cdef cython.uint week
    week,day = divmod(day, 7)
    if week==0: return f"{day} day{'' if day==1 else 's'}, {hr} hour{'' if hr==1 else 's'}, {min} minute{'' if min==1 else 's'}, and {sec:.1f} seconds"
    cdef cython.uint yr
    yr,week  = divmod(week,52)
    if yr  ==0: return f"{week} week{'' if week==1 else 's'}, {day} day{'' if day==1 else 's'}, {hr} hour{'' if hr==1 else 's'}, {min} minute{'' if min==1 else 's'}, and {sec:.1f} seconds"
    return f"{yr} year{'' if yr==1 else 's'}, {week} week{'' if week==1 else 's'}, {day} day{'' if day==1 else 's'}, {hr} hour{'' if hr==1 else 's'}, {min} minute{'' if min==1 else 's'}, and {sec:.1f} seconds"

cpdef str fmttimeit(str stmt="pass", str setup="pass", object timer=timeit.default_timer, cython.uint number=timeit.default_number, object globals=None):
    return format(timeit.timeit(stmt, setup, timer, number, globals), '.5f')
