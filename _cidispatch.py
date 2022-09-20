from __future__ import annotations

__all__ = [
    'CIDispatchMethod',
    'cidispatchmethod'
]

from .__common import *

class CIDispatchMethod:
    """Bind a classmethod and instance method such that they both work under the same name
    Type checkers unfortunately do not understand definition wise, but somewhat understand usages
    Example:
        class Test:
            @CIDispatchMethod
            def func(self):
                return 'self!'
            @func # noqa
            @classmethod
            def func(cls):
                return "cls!"
            def test(self):
                self.func() # calls instance version / prints "self!"
                self.__class__.func() # calls class version / prints "cls!"
    [Created 2/19/22]"""
    __slots__ = __match_args__ = ('finst','fcls')
    def __init__(self, f1:t.Optional[types.FunctionType], f2:t.Optional[classmethod], /):
        self.finst:t.Optional[types.FunctionType] = f1
        self.fcls:t.Optional[classmethod] = f2
    def __repr__(self):
        return f"{self.__class__.__name__}({self.finst}, {self.fcls})"
    def cls_func(self, fcls:classmethod) -> CIDispatchMethod:
        if not isinstance(fcls, classmethod):
            raise TypeError(f"Classmethod expected; got {type(fcls)}")
        self.fcls:classmethod = fcls
        return self
    def inst_func(self, finst:types.FunctionType) -> CIDispatchMethod:
        # noinspection PyTypeChecker
        if not isinstance(finst, types.FunctionType): # type checker being dumb here
            raise TypeError(f"Function expected; got {type(finst)}")
        # noinspection PyTypeChecker
        self.finst:types.FunctionType = finst # type checker being dumb here
        return self
    def __call__(self, f:types.FunctionType|classmethod, /):
        if isinstance(f, classmethod):
            self.fcls = f
            return self
        # noinspection PyTypeChecker
        if isinstance(f, types.FunctionType): # type checker being dumb here
            self.finst = f
            return self
        raise TypeError(f"Classmethod or function expected; got {type(f)}")
    @t.overload
    def __get__(self, instance:T, owner:t.Type[T]) -> types.MethodType: ...
    @t.overload
    def __get__(self, instance:None, owner:T) -> types.MethodType: ...
    def __get__(self, instance, owner):
        if not (fcls:=self.fcls): raise TypeError
        if not (finst:=self.finst): raise TypeError
        #    classmethod bind to class  if instance is None else  instancemethod bind to instance
        return fcls.__get__(None,owner) if instance is None else finst.__get__(instance,owner)

@t.overload
def cidispatchmethod(f:classmethod|types.FunctionType, /): ...
@t.overload
def cidispatchmethod(f1:classmethod, f2:types.FunctionType, /): ...
@t.overload
def cidispatchmethod(f1:types.FunctionType, f2:classmethod, /): ...
def cidispatchmethod(f1:classmethod|types.FunctionType, f2:None|classmethod|types.FunctionType=None, /):
    if isinstance(f1, classmethod):
        f1,f2 = f2,f1
    f1:types.FunctionType
    f2:classmethod
    return CIDispatchMethod(f1, f2)
