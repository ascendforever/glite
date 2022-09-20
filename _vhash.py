"""
VHash = virtually-hash
In Python hashing is generally reserved for immutable types
It is sometimes the case where we want hashing to be allowed for types that are mutable (and thus the hash changes)
This is where vhash comes in - it is essentially just normal hashing but with different names
"""
from __future__ import annotations

__all__ = [
    'TrulyHashable',
    'truly_hashable',
    'vhashable',
    'vhashable_strict',
    'check__vhash__signature',
    'VHashable',
    'vhash'
]

from .__common import *
from .__static import *

class TrulyHashableMeta(abc.ABCMeta):
    """[Created 4/3/22]"""
    __slots__ = ()
    def __instancecheck__(self, instance) -> bool:
        return implements__hash__(instance)
    def __subclasscheck__(self, subclass) -> bool:
        return implements__hash__(subclass)
if t.TYPE_CHECKING:
    class TrulyHashable(abcs.Hashable, metaclass=abc.ABCMeta):
        """Object which implements __hash__; Better than collections.abc.Hashable because that is considered True for object.__hash__ which is silly
        [Created 4/3/22]"""
        __slots__ = ()
        def __init_subclass__(cls, **kwargs): ...
else:
    class TrulyHashable(metaclass=TrulyHashableMeta):
        """Object which implements __hash__; Better than collections.abc.Hashable because that is considered True for object.__hash__ which is silly
        [Created 4/3/22]"""
        __slots__ = ()
        def __init_subclass__(cls, **kwargs):
            super().__init_subclass__(**kwargs)
            if not implements__hash__(cls):
                raise TypeError("Class must implement __hash__ (it cannot just be object.__hash__)")
truly_hashable = implements__hash__


def vhashable(obj) -> bool:
    """Check if an object is vhashable (implements __vhash__ or is hashable)
    [Created 4/3/22]"""
    return hasattr(obj, '__vhash__') or isinstance(obj, abcs.Hashable)
def vhashable_strict(obj) -> bool:
    """Check if an object is vhashable but is also not mixed with normal hashing or vice versa (implements __vhash__ xor is implements __hash__)
    [Created 4/3/22]"""
    return hasattr(obj, '__vhash__') ^ implements__hash__(obj)
def check__vhash__signature(__vhash__:abcs.Callable) -> bool:
    """Check if the signature of a __vhash__ is correct; It should be `(self) -> int` or `(self, /) -> int` or either with no return annotation
    [Created 4/3/22]"""
    return not not (
        len(params:=(sig:=inspect.signature(__vhash__)).parameters)==1 and (param:=params.get('self', False)) and
        ((kind:=param.kind)==inspect.Parameter.POSITIONAL_OR_KEYWORD or kind==inspect.Parameter.POSITIONAL_ONLY) and
        ((ra:=sig.return_annotation) is int or ra=='int' or ra is inspect.Signature.empty)
    )

class VHashableMeta(abc.ABCMeta):
    """[Created 4/3/22]"""
    __slots__ = ()
    def __instancecheck__(self, instance) -> bool:
        return vhashable(instance)
    def __subclasscheck__(self, subclass) -> bool:
        return vhashable(subclass)
class VHashable(metaclass=VHashableMeta):
    """Object which implements a hashing protocol for mutable objects
    [Created 4/3/22]"""
    __slots__ = ()
    def __init_subclass__(cls, **kwargs):
        if (b1:=hasattr(cls, '__vhash__')) ^ (b2:=implements__hash__(cls)): # same as vhashable_strict but unpacked here
            if b1 and not check__vhash__signature(cls.__vhash__):
                raise TypeError(f"__vhash__ signature incorrect; Should be `(self) -> int` or `(self, /) -> int` or either with no return annotation, not {inspect.signature(cls.__vhash__)}")
            return
        raise TypeError(f"Class must implement __vhash__ xor __hash__ to be considered VHashable at class construction; {'Both' if b1 and b2 else 'Neither'} implemented, when a single one should be")

def vhash(obj:VHashable|abcs.Hashable) -> int:
    """Calculate the hash of an object which may not be necessarily immutable
    VHashable objects must implement __vhash__ xor __hash__
    [Created 4/3/22]"""
    if f:=getattr(obj, '__vhash__', False): return f()
    try:
        __isinstance =  isinstance
        if __isinstance(obj, abcs.Hashable): return hash(obj)
        if __isinstance(obj, abcs.Mapping ): return hash(tuple(obj.items()))
        if __isinstance(obj, abcs.Sequence): return hash(tuple(obj))
    except TypeError as e:
        raise TypeError("Tried to hash() an unhashable object during vhash(). Maybe the object fails to be hashable during a certain state or when containing certain items") from e
    raise TypeError("vhash requires an object implement __vhash__ or __hash__")
