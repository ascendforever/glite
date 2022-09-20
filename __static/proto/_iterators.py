
from gll.__common import __common

_T = __common.T

@__common.t.runtime_checkable
class SizedIterable(__common.t.Protocol):
    def __iter__(self): ...
    def __len__(self): ...
