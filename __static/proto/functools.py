
from gll.__common import __common

_T = __common.T

if __common.t.TYPE_CHECKING:
    class CacheInfo(__common.t.NamedTuple):
        """At runtime is the actual implementation"""
        hits:int
        misses:int
        maxsize:int
        currsize:int
else:
    # noinspection PyProtectedMember, PyUnresolvedReferences
    CacheInfo = __common.functools._CacheInfo

class LRUCacheWrapperParameterDict(__common.t.TypedDict):
    maxsize:int
    typed:bool

if __common.t.TYPE_CHECKING:
    @__common.t.runtime_checkable
    class LRUCacheWrapper(__common.t.Protocol[_T]):
        """At runtime is the actual implementation"""
        def cache_parameters(self) -> LRUCacheWrapperParameterDict: ...
        def cache_info(self) -> CacheInfo: ...
        def cache_clear(self) -> None: ...
        __call__:_T
        # def __call__(self, /, *args, **kwargs) -> _T: ...
        def __copy__(self, /) -> None: ...
        def __deepcopy__(self, /) -> None: ...
        def __get__(self, instance, owner, /): ...
        def __reduce__(self): ...
else:
    # noinspection PyProtectedMember, PyUnresolvedReferences
    LRUCacheWrapper = __common.functools._lru_cache_wrapper
