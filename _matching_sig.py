from __future__ import annotations

__all__ = [
    'MatchingSignatureChecker'
]

from .__common import *

class MatchingSignatureChecker:
    """
    Checks that functions share the same signature
    Only argument passed to __init__ must be an `inspect.Signature` or `None`
        If it is an inspect.Signature, all checked functions will check their signature against that one
        Else, it will use the first function's signature
    If you want to check the desired signature, change `self.desired_sig`
    If you want to make the next function set the desired sig, change `self.desired_sig` to `None`
    Can be used as a context manager for readability
    `self.desired_sig` is set to `None` on context manager exit
    Can be reused
    Usage:
        with MatchingSignatureChecker() as msc:
            @msc # base signature
            def func1(first:int=2, second:str='g') -> str:
                ...
            @msc # checks with above... it is good
            def func2(first:int=2, second:str='g') -> str:
                ...
            @msc #  checks with original... it is bad
            def func3(first:float=2, second:str='g') -> str:
                ...
            @msc #  checks with original... it is bad
            def func4(first:int=2, secondddd:str='g') -> str:
                ...
        # or
        with MatchingSignatureChecker() as msc:
            msc(existing_func1)
            msc(existing_func2)
            msc(existing_func3)
            msc(existing_func4)
    [Created 8/10/21]
    """
    __slots__ = __match_args__ = ('desired_sig',)
    def __init__(self, /, existing_signature:t.Optional[inspect.Signature]=None):
        self.desired_sig:t.Optional[inspect.Signature] = existing_signature
    def _dec(self, /, function:abcs.Callable) -> t.Optional[inspect.Signature]:
        sig = inspect.signature(function)
        if ds:=self.desired_sig:
            if ds!=sig:
                return sig
        else:
            self.desired_sig = sig
        return None
    def __call__(self, function:abcs.Callable) -> abcs.Callable:
        """Raises `TypeError` on failure"""
        if not (sig := self._dec(function)): return function
        raise TypeError(f"Function signature did not match: got {sig}, needed {self.desired_sig}")
    def only_warn(self, function:abcs.Callable) -> abcs.Callable:
        """Issues a RuntimeError on failure"""
        if not (sig := self._dec(function)): return function
        warnings.warn(f"Function signature did not match: got {sig}, needed {self.desired_sig}", RuntimeWarning)
    def make_desired(self, function:abcs.Callable) -> abcs.Callable:
        """Change the desired signature to that of the passed function"""
        self.desired_sig = inspect.signature(function)
        return function
    def __enter__(self, /) -> MatchingSignatureChecker:
        return self
    def __exit__(self, /, exc_type, exc_val, exc_tb) -> None:
        """Sets `self.desired_sig` to `None`"""
        self.desired_sig = None
