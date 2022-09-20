
import gll.__common as __common

# -- RULES FOR NAMING CLASSES --
# Nice verbose name for a single method Ex: SupportsLessThanOrEqualTo
# Actual dunder names for multiple methods Ex: SupportsLtGtLeGeEqNe

SupportsAbs = __common.t.SupportsAbs
SupportsBytes = __common.t.SupportsBytes
SupportsIndex = __common.t.SupportsIndex
SupportsInt = __common.t.SupportsInt
SupportsFloat = __common.t.SupportsFloat
SupportsComplex = __common.t.SupportsComplex
SupportsRound = __common.t.SupportsRound

from ._arith import *
from ._arith_aug import *
from ._arith_refl import *
from ._comp import *
from ._conv import *
from ._decimal import *
from ._descriptor import *
from ._iterators import *
from ._unary import *
from . import functools















