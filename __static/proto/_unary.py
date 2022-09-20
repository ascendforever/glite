
from gll.__common import __common

_T = __common.T

@__common.t.runtime_checkable
class SupportsNeg(__common.t.Protocol[_T]):
    def __neg__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsPos(__common.t.Protocol[_T]):
    def __pos__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsPosNeg(__common.t.Protocol[_T]):
    def __pos__(self, /, other): ...
    def __neg__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsInvert(__common.t.Protocol[_T]):
    def __invert__(self, /, other): ...
