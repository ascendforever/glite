
from glite import __common

_T = __common.T

@__common.t.runtime_checkable
class SupportsBool(__common.t.Protocol[_T]):
    def __bool__(self, /) -> bool: ...
@__common.t.runtime_checkable
class SupportsRepr(__common.t.Protocol[_T]):
    def __repr__(self, /) -> str: ...
@__common.t.runtime_checkable
class SupportsStr(__common.t.Protocol[_T]):
    def __str__(self, /) -> str: ...
@__common.t.runtime_checkable
class SupportsFormat(__common.t.Protocol[_T]):
    def __format__(self, /, format_spec) -> str: ...
@__common.t.runtime_checkable
class SupportsStrRepr(__common.t.Protocol[_T]):
    def __str__(self, /) -> str: ...
    def __repr__(self, /) -> str: ...
@__common.t.runtime_checkable
class SupportsStrReprFormat(__common.t.Protocol[_T]):
    def __str__(self, /) -> str: ...
    def __repr__(self, /) -> str: ...
    def __format__(self, /, format_spec) -> str: ...
