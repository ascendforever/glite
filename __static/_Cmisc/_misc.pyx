
__all__ = [
    'sentinel',
    'isnone',
    'filter_not_none',
    'filter_type',
    'anymap',
    'allmap',
    'anynone',
    'allnone',
    'exhaust',
    'yyf',
    'yfy',
    'yyfy',
    'enumerate1',
    'padded_hex',
    'multidec',
    'natural_commas',
    'lenlongestfrom',
    'inline_decorate',
    'debug_print',
    'exc_tb_lines',
    'exc_tb_lines_lazy',
    'filter_slices',
    'group_sliced_true',
    'group_sliced_either',
    'group_sliced_deferred',
    'empty_range',
    # 'len_range_pyint',
    'len_range',
    # 'last_of_range_pyint',
    'last_of_range',
    'throw',
    'implements__hash__',
]

from glite.__common import *

cimport cython
from cpython cimport int as PyInt

sentinel:t.Final = object()

cpdef bint isnone(object obj):
    return obj is None

cpdef object filter_not_none(object iterable): # iterable:col.abc.Iterable[t.Optional[T]] # return col.abc.Iterator[T]
    return itertools.filterfalse(isnone, iterable)
# noinspection PyShadowingBuiltins
cpdef object filter_type(object type, object iterable): # type:t.Union[type,tuple[type,...]], iterable:col.abc.Iterable[T] # return col.abc.Iterator[T]:
    return filter(functools.partial(isinstance, __class_or_tuple=type), iterable)
cpdef bint anymap(object func, object iterable): # (func:col.abc.Callable[...,t.Any], iterable:col.abc.Iterable[t.Any]) -> bool:
    return any(map(func, iterable))
cpdef bint allmap(object func, object iterable): # (func:col.abc.Callable[...,t.Any], iterable:col.abc.Iterable[t.Any]) -> bool:
    return all(map(func, iterable))
cpdef bint anynone(object iterable): # (iterable:col.abc.Iterable[t.Union[None,t.Any]]) -> bool:
    """Return any(map(isnone, iterable))"""
    return any(map(isnone, iterable))
cpdef bint allnone(object iterable): # (iterable:col.abc.Iterable[t.Union[None,t.Any]]) -> bool:
    """Return all(map(isnone, iterable))"""
    return all(map(isnone, iterable))

cpdef void exhaust(object it): # (it:col.abc.Iterable) -> None:
    for _ in it: pass # this better for SMALLER iterables; col.deque(it, maxlen=0) has overhead for creation but is FASTER when exhausting, thus it is better with LONGER iterables

def yyf(object pre, object it) -> col.abc.Generator: # (pre:T, it:col.abc.Iterable[Y]) -> col.abc.Generator[t.Union[T,Y], None, None]:
    """Simply yields first argument, then yields from the second; More efficient when you would normally need to create an unnecessary iterable for itertools.chain"""
    yield pre
    yield from it
def yfy(object it, object final) -> col.abc.Generator: # (it:col.abc.Iterable[Y], final:T) -> col.abc.Generator[t.Union[T,Y], None, None]:
    """Simply yields from the first argument, then yields the second; More efficient when you would normally need to create an unnecessary iterable for itertools.chain"""
    yield from it
    yield final
def yyfy(object pre, object it, object final) -> col.abc.Generator: # (pre:T, it:col.abc.Iterable[Y], final:T) -> col.abc.Generator[t.Union[T,Y], None, None]:
    """Simply yields the first argument, then yields from the second, then yields the third; More efficient when you would normally need to create an unnecessary iterable for itertools.chain"""
    yield pre
    yield from it
    yield final

cpdef object enumerate1(object iterable): # (iterable:col.abc.Iterable[T]) -> col.abc.Iterator[tuple[builtins.int,T]]:
    return enumerate(iterable,1)


# def cached_property(function:col.abc.Callable[..., T]=None, /, maxsize:t.Optional[int]=1, typed:bool=False):
#     """Equivalent for `functools.cached_property`, but supports __slots__"""
#     if function is None:
#         return functools.partial(cached_property, maxsize=maxsize, typed=typed)
#     return property(functools.lru_cache(maxsize=maxsize, typed=typed)(function))

cpdef str padded_hex(object val, cython.uchar pad_size=16):
    return f'0x{val:0{pad_size}X}'

def multidec(object final, *decorators) -> col.abc.Callable: # (final:col.abc.Callable[...,col.abc.Callable[...,T]], *decorators:col.abc.Callable[...,col.abc.Callable]) -> col.abc.Callable[[col.abc.Callable], col.abc.Callable[...,T]]:
    """Apply multiple decorators; type checkers do not understand this"""
    def decorator(object func) -> col.abc.Callable: # (func:col.abc.Callable) -> col.abc.Callable:
        for deco in reversed(decorators):
            func = deco(func)
        return final(func)
    return decorator

cpdef str natural_commas(object texts, str delimiter=','):# (texts:col.abc.Sequence[str], delimiter:str=',') -> str:
    cdef cython.ushort lt = len(texts)
    if lt >= 3: return f"{f'{delimiter} '.join(texts[:-1])}{delimiter} and {texts[-1]}"
    if lt == 2: return f"{texts[0]} and {texts[1]}"
    if lt == 1: return texts[0]

cpdef cython.uint lenlongestfrom(object iterable):# (iterable:col.Iterable[col.Sized]) -> builtins.int:
    # No more deprecation warning because this is still easier to read
    # warnings.warn(f"{lenlongestfrom.__name__} is deprecated; use `max(map(len,iterable))` instead", DeprecationWarning)
    # long:int = 0
    # # NOTE: using map(len, iterable) is only SLIGHTLY faster for non lazy iterators, but using a check ruins that performance gain, so this is best
    # for x in iterable: # type: col.abc.Sized
    #     if (y := len(x)) > long:
    #         long = y
    # return long
    # -----------
    # this seems to be better than the old version, even though my previous comment says otherwise
    # first is the above type, second is the max mapping type
    # with sequence
    # 1.33881530
    # 0.9655442000000001
    # with lazy
    # 7.896598000000001
    # 7.033659500000001
    # max *\( *map *\( *len *, *.+\) *\)
    return max(map(len,iterable))

def inline_decorate(anticipator:t.Optional[col.abc.Callable[ [dict[str,t.Any]], t.Any ]]=None,
                    finalizer  :t.Optional[col.abc.Callable[ [dict[str,t.Any], T], T ]]=None):
    """Add a simple before (anticipator) and after (finalizer) call to a function;
    Each take `locals()` as the first argument
    finalizer takes the result as the second argument, and the return should also be the result"""
    def deco(func:col.abc.Callable[..., T]):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            if anticipator is not None:
                anticipator(locals())
            result = func(*args, **kwargs)
            if finalizer is not None:
                result = finalizer(locals(), result)
            return result
        return wrapper
    return deco


def debug_print(*values, str sep=' ', str end='\n', object file=sys.stdout, bint flush=False) -> tuple:
    print(*values, sep=sep, end=end, file=file, flush=flush)
    return values

cpdef object exc_tb_lines(object etype, object exc, object tb, object limit=None, cython.bint chain=True):
    # TAKEN AND EDITED FROM traceback.print_exception
    return traceback.TracebackException(etype, exc, tb, limit=limit).format(chain=chain)
cpdef object exc_tb_lines_lazy(object exception, object limit=None, cython.bint chain=True):
    return traceback.TracebackException(type(exception), exception, exception.__traceback__, limit=limit).format(chain=chain)

def filter_slices(object check, object data) -> col.abc.Generator: # (check:col.abc.Callable[[T], cython.bint], data:col.abc.Sequence[T]):
    cdef cython.uint i
    cdef object fi = None
    for i,obj in enumerate(data):
        if fi is None: # if the current group is empty
            if check(data):
                fi = i # make this the first of the group
        else:
            if check(data):
                pass # do nothing as it will be in the current group
            else: # else
                yield slice(fi, i) # send the group
                fi = None # empty the group
def group_sliced_true(object check, object data) -> col.abc.Generator: # (check:col.abc.Callable[[T], cython.bint], data:col.abc.Sequence[T]):
    cdef cython.uint i
    cdef object fi = None
    # noinspection PyShadowingBuiltins
    slice = builtins.slice
    for i,obj in enumerate(data):
        if fi is None: # if the current group is empty
            if check(obj):
                fi = i # make this the first of the group
            else:
                yield slice(i,i+1) # send this one out
        else:
            if check(obj):
                pass # do nothing as it will be in the current group
            else:
                yield slice(fi, i) # send the group
                fi = None # empty the group
                yield slice(i,i+1) # send this one out
    if fi is not None: # if there is a remaining group
        yield slice(fi,len(data)) # send it out
def group_sliced_either(object check, object data) -> col.abc.Generator: # (check:col.abc.Callable[[T], cython.bint], data:col.abc.Sequence[T]):
    cdef cython.uint i
    cdef object fci = None # first correct i
    cdef object fbi = None # first bad i
    # noinspection PyShadowingBuiltins
    cdef object slice = builtins.slice
    # noinspection PyShadowingBuiltins
    cdef object len = builtins.len
    for i,obj in enumerate(data):
        if check(obj): # if the data is good
            if fbi is not None: # if the bad isn't empty
                yield slice(fbi, i) # dump the bad
                fbi = None
            if fci is None: # if the good has no group
                fci = i # start it
        else: # if the data is bad
            if fci is not None: # if the good isn't empty
                yield slice(fci, i) # dump the good
                fci = None
            if fbi is None: # if the bad has no group
                fbi = i # start it
    # if there is a remaining group send it
    if fci is not None:
        yield slice(fci,len(data))
    elif fbi is not None:
        yield slice(fci,len(data))
def group_sliced_deferred(object check, object data) -> col.abc.Generator: # (check:col.abc.Callable[[T], cython.bint], data:col.abc.Sequence[T]):
    # noinspection PyShadowingBuiltins
    cdef object slice = builtins.slice
    cdef list fails = [] # of slice
    cdef object __fails_append = fails.append
    cdef object fi = None
    # noinspection PyShadowingBuiltins
    cdef object len = builtins.len
    for i,obj in enumerate(data):
        if fi is None: # if the current group is empty
            if check(obj):
                fi = i # make this the first of the group
            else: # else
                __fails_append(slice(i,i+1)) # send this one
        else:
            if check(obj):
                pass # do nothing as it will be in the current group
            else: # else
                yield slice(fi, i) # send the group
                fi = None # empty the group
                __fails_append(slice(i,i+1)) # send this one out
    if fi is not None: # if there is a remaining group
        yield slice(fi,len(data)) # send it out
    yield from fails # send those who failed


cpdef bint empty_range(PyInt start, PyInt stop, PyInt step=1):
    return start*(-1 if step < 0 else 1) > stop
cpdef bint empty_slice(PyInt start, PyInt stop, PyInt step=1):
    if start < 0 and stop > 0:
        return True
    return start*(-1 if step < 0 else 1) > stop
cpdef PyInt len_range(PyInt start, PyInt stop, PyInt step=1):
    cdef PyInt ans
    try:
        ans = (last_of_range(0, stop-start, step) // step) + 1
    except ValueError: # means the slice was empty because the step goes away from the start and stop ex: 1:10:-1 or 10:1:1
        return 0
    if ans <= 0:
        return 0
    return ans
# cpdef cython.uint len_range(cython.uint start, cython.uint stop, cython.uint step=1) nogil:
#     cdef cython.uint ans = (last_of_range(0, stop-start, step) // step) + 1
#     if ans <= 0:
#         return 0
#     return ans
cpdef PyInt last_of_range(PyInt start, PyInt stop, PyInt step=1):
    if empty_range(start, stop, step): # empty slice
        raise ValueError(f"Empty range {start}:{stop}:{step}")
    return step*((stop-1-start)//step)+start
# cpdef cython.uint last_of_range(cython.uint start, cython.uint stop, cython.uint step=1) nogil:
#     return step*((stop-1-start)//step)+start

def throw(object type, *objects, object from_=None) -> t.NoReturn:
    raise type(*objects) from from_

cpdef bint implements__hash__(object obj):
    cdef object cls = type(obj)
    if issubclass(cls, type): # no metaclasses
        cls = obj
    return issubclass(cls, col.abc.Hashable) and cls.__hash__ is not object.__hash__



# # probably useless but still idk yet
# class StringIOAuto(io.StringIO):
#     """StringIO with automatic saving of results to attribute `result`
#     [Created 11/15/21]"""
#     def __init__(self):
#         super().__init__()
#         self.result:t.Optional[str] = None
#     def __enter__(self) -> io.StringIO:
#         return super().__enter__()
#     def __exit__(self, exc_type, exc_val, exc_tb):
#         self.result = self.getvalue()
#         return super().__exit__(exc_type, exc_val, exc_tb)









# def shbcache_caller(shbcache):
#     return lambda self,*a,**b : shbcache(self,*a,**b)
# class SHBCache(t.Generic[T]):
#     """Implementation for a single cached value, where it is updated if an instance hash changes
#     Function MUST take at least one argument
#     The first argument MUST be hashable and will be what the cache is based off"""
#     __slots__ = ('_hash', '_cached')
#     def __init__(self):
#         self._hash:int = -1.1 # INTENTIONAL: this will ALWAYS evaluate to false when we havent computed yet since hash functions return INTEGERS
#         self._cached:T = ...
#     def __hash__(self) -> int:
#         return hash(self._function)
#     def as_property(self, /, function:col.abc.Callable[..., T]) -> property:
#         return property(self(function))
#     def __call__(inst, function:T) -> T:
#         @functools.wraps(function)
#         def get(self:col.abc.Hashable, *args, **kwargs):
#             if (insthash:=hash(self))!=inst._hash:
#                 inst._hash = insthash
#                 inst._cached = function(self, *args, **kwargs)
#             return inst._cached
#         return get

# def shb_cache(function:T) -> T:
#     hashed = col.defaultdict(default_factory=lambda : -1.1
#     cached:T = ...
#     @functools.wraps(function)
#     def getter(self:col.abc.Hashable, *args,**kwargs):
#         nonlocal hashed, cached
#         if (insthash:=hash(self))!=hashed:
#             print('calc')
#             hashed = insthash
#             cached = function(self, *args, **kwargs)
#         return cached
#     return getter
