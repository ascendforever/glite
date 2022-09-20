
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

sentinel:t.Final = object()

@t.overload
def isnone(obj:t.Literal[None]) -> t.Literal[True]: ...
@t.overload
def isnone(obj:t.Any) -> bool: ...
def isnone(obj:t.Any) -> bool:
    return obj is None

# noinspection PyUnusedLocal
def filter_not_none(iterable:abcs.Iterable[t.Optional[T]]) -> abcs.Iterator[T]: ...
# noinspection PyUnusedLocal
# noinspection PyShadowingBuiltins
def filter_type(type:builtins.type|tuple[builtins.type,...], iterable:abcs.Iterable[T]) -> abcs.Iterator[T]: ...
# noinspection PyUnusedLocal
def anymap(func:abcs.Callable[...,t.Any], iterable:abcs.Iterable[t.Any]) -> bool:
    """Return any(map(func, *iterables))"""
# noinspection PyUnusedLocal
def allmap(func:abcs.Callable[...,t.Any], iterable:abcs.Iterable[t.Any]) -> bool:
    """Return all(map(func, *iterables))"""
# noinspection PyUnusedLocal
def anynone(iterable:abcs.Iterable[None|t.Any]) -> bool:
    """Return any(map(isnone, iterable))"""
# noinspection PyUnusedLocal
def allnone(iterable:abcs.Iterable[None|t.Any]) -> bool:
    """Return all(map(isnone, iterable))"""

# noinspection PyUnusedLocal
def exhaust(it:abcs.Iterable) -> None: ...

Y = t.TypeVar('Y')
# noinspection PyUnusedLocal
def yyf(pre:T, it:abcs.Iterable[Y]) -> abcs.Generator[T|Y, None, None]:
    """Simply yields first argument, then yields from the second; More efficient when you would normally need to create an unnecessary iterable for itertools.chain"""
# noinspection PyUnusedLocal
def yfy(it:abcs.Iterable[Y], final:T) -> abcs.Generator[T|Y, None, None]:
    """Simply yields from the first argument, then yields the second; More efficient when you would normally need to create an unnecessary iterable for itertools.chain"""
# noinspection PyUnusedLocal
def yyfy(pre:T, it:abcs.Iterable[Y], final:T) -> abcs.Generator[T|Y, None, None]:
    """Simply yields the first argument, then yields from the second, then yields the third; More efficient when you would normally need to create an unnecessary iterable for itertools.chain"""

# noinspection PyUnusedLocal
def enumerate1(iterable:abcs.Iterable[T]) -> abcs.Iterator[tuple[builtins.int,T]]:
    """`builtins.enumerate`, starting from 1
    Better because it is easy to miss the 1 in enumerate"""

# noinspection PyUnusedLocal
def padded_hex(val:builtins.int, *, pad_size:int=16) -> str: ...

# noinspection PyUnusedLocal
def multidec(final:abcs.Callable[...,abcs.Callable[...,T]], *decorators:abcs.Callable[...,abcs.Callable]) -> abcs.Callable[[abcs.Callable], abcs.Callable[...,T]]:
    """Apply multiple decorators; type checkers do not understand this"""

# noinspection PyUnusedLocal
def natural_commas(texts:abcs.Sequence[str], delimiter:str=',') -> str:
    """Add grammatically correct commas"""

# noinspection PyUnusedLocal
def lenlongestfrom(iterable:col.Iterable[col.Sized]) -> int:
    """
    Get the `len` of the `longest` `from` and iterable
    :param iterable: Source
    :return: Length of the longest item of source iterable
    """

# noinspection PyUnusedLocal
def inline_decorate(anticipator:t.Optional[abcs.Callable[ [dict[str,t.Any]], t.Any ]]=None,
                    finalizer  :t.Optional[abcs.Callable[ [dict[str,t.Any], T], T ]]=None):
    """Add a simple before (anticipator) and after (finalizer) call to a function;
    Each take `locals()` as the first argument
    finalizer takes the result as the second argument, and the return should also be the result"""


# noinspection PyUnusedLocal
def debug_print(*values:object, sep:t.Optional[str]=' ', end:t.Optional[str]='\n', file:t.Optional[io.IOBase]=sys.stdout, flush:t.Optional[bool]=False):
    """Print and then return unchanged"""

# noinspection PyUnusedLocal
def exc_tb_lines(etype:t.Type[BaseException], exc:BaseException, tb:types.TracebackType, limit:t.Any=None, chain:bool=True) -> abcs.Generator[str, t.Any, None]:
    """Stringify exception and traceback and yield lines
    Each line has a trailing newline
    etype = exception type
    value = exception
    tb = exception traceback
    [Created 11/13/21]"""
# noinspection PyUnusedLocal
def exc_tb_lines_lazy(exception:BaseException, limit:t.Any=None, chain:bool=True):
    """Same as standard counterpart but gets all information from the plain exception
    [Created 11/13/21]"""

# noinspection PyUnusedLocal
def filter_slices(check:abcs.Callable[[T], bool], data:abcs.Sequence[T]):
    """Yields slices of data in which each slice is the slice of objects who succeeded the check in a row; those who fail are discarded
    [Created 11/17/21]"""
# noinspection PyUnusedLocal
def group_sliced_true(check:abcs.Callable[[T], bool], data:abcs.Sequence[T]):
    """Yields slices of data in which each slice is the slice of objects who succeeded the check or a slice of one object who failed or succeeded and is surrounded by those who failed
    [Created 11/17/21]"""
# noinspection PyUnusedLocal
def group_sliced_either(check:abcs.Callable[[T], bool], data:abcs.Sequence[T]):
    """Yields slices of data in which each slice is the slice of consecutive objects who succeeded the check or slices of those who failed
    [Created 11/17/21]"""
# noinspection PyUnusedLocal
def group_sliced_deferred(check:abcs.Callable[[T], bool], data:abcs.Sequence[T]):
    """Yields slices of data in which each slice is the slice of objects who succeeded the check, and the final yields are those who failed
    [Created 11/17/21]"""

# def len_range_pyint(start:int, stop:int, step:int) -> int:
#     """Get the length of a range (use if standard version uses ints larger than int64)
#     [Created 2/12-14/22]"""
def empty_range(start:int, stop:int, step:int=1) -> bool:
    """Check if a range is empty
    [Created 4/19/20]"""
def len_range(start:int, stop:int, step:int=1) -> int:
    """Get the length of a range
    [Created 2/12-14/22]"""
# def last_of_range_pyint(start:int, stop:int, step:int) -> int:
#     """Get the last of a range (use if standard version uses ints larger than int64) (NO NEGATIVES)
#     [Created 2/12-14/22]"""
#     return step*((stop-1-start)//step)+start
def last_of_range(start:int, stop:int, step:int=1) -> int:
    """Get the last of a range
    [Created 2/12-14/22]"""

def throw(type:t.Type[BaseException], *objects, from_=None) -> t.NoReturn:
    """Raise an exception"""

def implements__hash__(obj) -> bool:
    """Checks if an object actually implements __hash__ (does not count if it is object.__hash__)
    [Created 4/3/22]"""
