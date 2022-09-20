
from gll.__common import __common

_T = __common.T

@__common.t.runtime_checkable
class SupportsRAdd(__common.t.Protocol[_T]):
    def __radd__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsRSub(__common.t.Protocol[_T]):
    def __rsub__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsRAddRSub(__common.t.Protocol[_T]):
    def __radd__(self, /, other): ...
    def __rsub__(self, /, other): ...

@__common.t.runtime_checkable
class SupportsRMul(__common.t.Protocol[_T]):
    def __rmul__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsRTruediv(__common.t.Protocol[_T]):
    def __rtruediv__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsRFloordiv(__common.t.Protocol[_T]):
    def __rfloordiv__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsRTruedivRFloordiv(__common.t.Protocol[_T]):
    def __rtruediv__(self, /, other): ...
    def __rfloordiv__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsRMulRTruedivRFloordiv(__common.t.Protocol[_T]):
    def __rmul__(self, /, other): ...
    def __rtruediv__(self, /, other): ...
    def __rfloordiv__(self, /, other): ...

@__common.t.runtime_checkable
class SupportsRMod(__common.t.Protocol[_T]):
    def __rmod__(self, /, other): ...