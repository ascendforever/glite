from __future__ import annotations

__all__ = [
    'multimap'
]

from .__common import *
from .__static import *

class multimap(t.Generic[T], abcs.Iterator[T]):
    """Apply a chain of functions onto an iterable
    Ex: multi_map(f2, f1, it=range(10)) === map(f2, map(f1, range(10)))
    Should not be reused
    [Created 5/?/21]"""
    __slots__ = ('_it', '__weakref__')
    __match_args__ = ('_it',)
    def __init__(self, /, final:abcs.Callable[[t.Any], T], *funcs:abcs.Callable[[t.Any], t.Any], it:abcs.Iterable):
        # noinspection PyShadowingBuiltins
        map = builtins.map
        for func in reversed(funcs):
            it:abcs.Iterator = map(func, it)
        self._it:abcs.Iterator[T] = map(final, it)
    # def __repr__(self) -> str:
    #     return f"<{self.__class__.__name__}(...) it={self._it!r}>"
    def append(self, /, func:abcs.Callable[[T], Y]) -> 'multimap[Y]':
        """Add a map onto the existing; returns `self`"""
        self._it:abcs.Iterator = map(func, self._it)
        return self
    def extend(self, final:abcs.Callable[[t.Any], T], /, *funcs:abcs.Callable[[t.Any], t.Any]) -> multimap[T]:
        """Add multiple maps onto the existing; returns `self`"""
        it = self._it
        map = builtins.map
        for func in reversed(funcs):
            it:abcs.Iterator = map(func, it)
        self._it:abcs.Iterator[T] = map(final, it)
        return self
    def __next__(self, /) -> T:
        return next(self._it)
    def __iter__(self, /) -> abcs.Iterator[T]:
        return self._it
