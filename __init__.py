



from sys import version_info as ____version_info
if ____version_info >= (3,9,2):
    from warnings import warn as ____warn
    ____warn(f"Python version should be 3.9 or greater", ImportWarning)

PYXIMPORT_INSTALLED:bool = False
from .import __common as _ # for the checks
try:
    from .__static import *
    from ._Cintbytes import *
    from ._Ctime import *
    from ._cidispatch import *
    from ._matching_sig import *
    from ._multimap import *
    from ._vhash import *
except ImportError:
    from platform import system as ____system
    if True:
        from pyximport import install as ____pyximport_install
        from warnings import warn as ____warn
        ____warn("Pyximport has been installed because this is the first time the package is running", ImportWarning)
        # you cannot redirect pyximport compilation messages # seem to only appear on Windows
        ____pyximport_install(language_level=3, inplace=True)
        PYXIMPORT_INSTALLED = True
        from . import __static as _
        from . import _Cintbytes as _
        from . import _Ctime as _
        from . import _cidispatch as _
        from . import _matching_sig as _
        from . import _multimap as _
        from . import _vhash as _
    from .__static import *
    from ._Cintbytes import *
    from ._Ctime import *
    from ._cidispatch import *
    from ._matching_sig import *
    from ._multimap import *
    from ._vhash import *


__version__ = '1.0.0'
