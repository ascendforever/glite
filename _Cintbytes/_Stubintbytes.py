
__all__ = [
    'ipy_size',
    'upy_size',
    'upy_to_bytes',
    'ipy_to_bytes',
    'u8_to_bytes',
    'u16_to_bytes',
    'u32_to_bytes',
    'u64_to_bytes',
    'i8_to_bytes',
    'i16_to_bytes',
    'i32_to_bytes',
    'i64_to_bytes',
    'u16_from_bytes_padded',
    'i16_from_bytes_padded',
    'u32_from_bytes_padded',
    'i32_from_bytes_padded',
    'u64_from_bytes_padded',
    'i64_from_bytes_padded',
    # 'u8_from_bytes',
    # 'i8_from_bytes',
    'u16_from_bytes',
    'i16_from_bytes',
    'u32_from_bytes',
    'i32_from_bytes',
    'u64_from_bytes',
    'i64_from_bytes',
    'upy_from_bytes',
    'ipy_from_bytes',
    'byteify',
]

from gll.__common import *

def upy_size(x:int) -> int: ... # noqa
def ipy_size  (x:int) -> int: ... # noqa

def upy_to_bytes(x:int) -> bytes: ... # noqa
def ipy_to_bytes(x:int) -> bytes: ... # noqa

def  u8_to_bytes(x:int) -> bytes: ... # noqa
def  i8_to_bytes(x:int) -> bytes: ... # noqa
def u16_to_bytes(x:int) -> bytes: ... # noqa
def i16_to_bytes(x:int) -> bytes: ... # noqa
def u32_to_bytes(x:int) -> bytes: ... # noqa
def i32_to_bytes(x:int) -> bytes: ... # noqa
def u64_to_bytes(x:int) -> bytes: ... # noqa
def i64_to_bytes(x:int) -> bytes: ... # noqa

def u16_from_bytes_padded(x:bytes) -> int: ... # noqa
def i16_from_bytes_padded(x:bytes) -> int: ... # noqa
def u32_from_bytes_padded(x:bytes) -> int: ... # noqa
def i32_from_bytes_padded(x:bytes) -> int: ... # noqa
def u64_from_bytes_padded(x:bytes) -> int: ... # noqa
def i64_from_bytes_padded(x:bytes) -> int: ... # noqa

def  u8_from_bytes(x:bytes) -> int: ... # noqa
def  i8_from_bytes(x:bytes) -> int: ... # noqa
def u16_from_bytes(x:bytes) -> int: ... # noqa
def i16_from_bytes(x:bytes) -> int: ... # noqa
def u64_from_bytes(x:bytes) -> int: ... # noqa
def i64_from_bytes(x:bytes) -> int: ... # noqa
def u32_from_bytes(x:bytes) -> int: ... # noqa
def i32_from_bytes(x:bytes) -> int: ... # noqa

def upy_from_bytes(x:bytes) -> int: ... # noqa
def ipy_from_bytes(x:bytes) -> int: ... # noqa

# noinspection PyShadowingBuiltins
# noinspection PyUnusedLocal
def byteify(bytes:int, decimals:int=17) -> str:
    """Quickly convert bytes to the highest practical unit
    [Created ?/?/20] cython // python 5/30/21"""




