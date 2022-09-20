
from gll.__common import __common

_T = __common.T

@__common.t.runtime_checkable
class SupportsAdd(__common.t.Protocol[_T]):
    def __add__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsSub(__common.t.Protocol[_T]):
    def __sub__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsAddSub(__common.t.Protocol[_T]):
    def __add__(self, /, other): ...
    def __sub__(self, /, other): ...

@__common.t.runtime_checkable
class SupportsMul(__common.t.Protocol[_T]):
    def __mul__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsTruediv(__common.t.Protocol[_T]):
    def __truediv__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsFloordiv(__common.t.Protocol[_T]):
    def __floordiv__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsTruedivFloordiv(__common.t.Protocol[_T]):
    def __truediv__(self, /, other): ...
    def __floordiv__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsMulTruedivFloordiv(__common.t.Protocol[_T]):
    def __mul__(self, /, other): ...
    def __truediv__(self, /, other): ...
    def __floordiv__(self, /, other): ...

@__common.t.runtime_checkable
class SupportsMod(__common.t.Protocol[_T]):
    def __mod__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsDivmod(__common.t.Protocol[_T]):
    def __divmod__(self, /, other): ...
@__common.t.runtime_checkable
class SupportsModDivmod(__common.t.Protocol[_T]):
    def __mod__(self, /, other): ...
    def __divmod__(self, /, other): ...
