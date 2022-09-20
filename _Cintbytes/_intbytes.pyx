
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

from glite.__common import *

from cpython cimport array
from cpython.bytes cimport PyBytes_AS_STRING # , PyBytes_FromString, PyBytes_FromStringAndSize, PyBytes_AsString
# from cpython.mem cimport PyMem_Malloc, PyMem_Free, PyMem_RawMalloc, PyMem_RawFree
from glite.__static.__cimports cimport *

cdef extern from "<math.h>" nogil:
    float ceilf(float)

# cpdef cython.uint upy_size_slow(PyInt x):
#     cdef cython.uint ln
#     cdef cython.uchar bonus
#     ln,bonus = divmod(int.bit_length(x), 8)
#     return ln if bonus==0 else ln+1 # need to round up a byte even if we just need one more bit

# only reason we copied these, is for possible benefits of inlining
cdef inline cython.uint _upy_size(PyInt x): return <cython.uint>ceilf(int.bit_length(x) / 8)
cdef inline cython.uint _ipy_size(PyInt x): return <cython.uint>ceilf(int.bit_length(x) / 8) + 1
cpdef cython.uint upy_size(PyInt x):        return <cython.uint>ceilf(int.bit_length(x) / 8) # yes ceilf is faster than math.ceil!
cpdef cython.uint ipy_size(PyInt x):        return <cython.uint>ceilf(int.bit_length(x) / 8) + 1

cdef array.array stringtemplate = array.array('B')

# cdef inline bytes any_to_bytes(int_any x): # pointless loop, separete funcs are better
#     cdef cython.uchar size = sizeof(int_any)
#     cdef char* as_chars = array.clone(stringtemplate, size, False).data.as_chars
#     cdef cython.uchar i
#     cdef char y
#     cdef cython.uchar start = sizeof(int_any)-1
#     for i in range(start, -1, -1):
#     # for i in range(sizeof(cython.ulonglong)): # this makes it little endian
#         as_chars[i] = y = <char>x
#         if y!=0:
#             start = i
#         x >>= 8
#     return as_chars[start:size]
#     # return PyBytes_FromString(as_chars[start:size]) # useless
cdef inline bytes  any8_to_bytes(u8_or_i8 x):
    cdef array.array arr = array.clone(stringtemplate, 1, False)
    cdef char* chars = arr.data.as_chars
    chars[0] = <char>x
    return arr[0:1].tobytes()
cdef inline bytes any16_to_bytes(u16_or_i16 x):
    cdef array.array arr = array.clone(stringtemplate, 2, False)
    cdef char* chars = arr.data.as_chars
    cdef cython.char y
    chars[1] = <char>x
    cdef cython.uchar start = 1
    chars[0] = y = <char>(x >> 8)
    if y!=0: start = 0
    return arr[start:2].tobytes()
cdef inline bytes any32_to_bytes(u32_or_i32 x):
    cdef array.array arr = array.clone(stringtemplate, 4, False)
    cdef char* chars = arr.data.as_chars
    cdef cython.char y
    chars[3] = <char>x
    cdef cython.uchar start = 3
    chars[2] = y = <char>(x >> 8)
    if y!=0: start = 2
    chars[1] = y = <char>(x >> 16)
    if y!=0: start = 1
    chars[0] = y = <char>(x >> 24)
    if y!=0: start = 0
    return arr[start:4].tobytes()
cdef inline bytes any64_to_bytes(u64_or_i64 x):
    cdef array.array arr = array.clone(stringtemplate, 8, False)
    cdef char* chars = arr.data.as_chars
    # cdef char* chars = <char*>PyMem_RawMalloc(8) # NEITHER OF THESE REALLY WORKED
    # cdef bytes pb = PyBytes_FromStringAndSize(NULL, 9)
    # cdef char* chars = PyBytes_AsString(pb)
    cdef char y
    cdef cython.uchar start = 7
    chars[7] = <char>x
    chars[6] = y = <char>(x >> 8)
    if y!=0: start = 6
    chars[5] = y = <char>(x >> 16)
    if y!=0: start = 5
    chars[4] = y = <char>(x >> 24)
    if y!=0: start = 4
    chars[3] = y = <char>(x >> 32)
    if y!=0: start = 3
    chars[2] = y = <char>(x >> 40)
    if y!=0: start = 2
    chars[1] = y = <char>(x >> 48)
    if y!=0: start = 1
    chars[0] = y = <char>(x >> 56)
    if y!=0: start = 0
    return arr[start:8].tobytes()

cpdef bytes upy_to_bytes(PyInt x):
    if 0 <= x <= 0xffffffffffffffff: # (1<<64)-1
        return u64_to_bytes(x)
    return PyInt.to_bytes(x, _upy_size(x), 'big', signed=False)
cpdef bytes ipy_to_bytes(PyInt x):
    if -0x8000000000000000 <= x <= 0x7fffffffffffffff: # -1<<63 & (1<<63)-1
        return i64_to_bytes(x)
    return PyInt.to_bytes(x, _ipy_size(x), 'big', signed=True)

cpdef bytes  u8_to_bytes(cython.uchar x):  return any8_to_bytes(x)
cpdef bytes  i8_to_bytes( cython.char x):  return any8_to_bytes(x)
cpdef bytes u16_to_bytes(cython.ushort x): return any16_to_bytes(x)
cpdef bytes i16_to_bytes( cython.short x): return any16_to_bytes(x)
cpdef bytes u32_to_bytes(cython.ulong x): return any32_to_bytes(x)
cpdef bytes i32_to_bytes( cython.long x): return any32_to_bytes(x)
cpdef bytes u64_to_bytes(cython.ulonglong x): return any64_to_bytes(x)
cpdef bytes i64_to_bytes( cython.longlong x): return any64_to_bytes(x)

cpdef cython.ushort u16_from_bytes_padded(bytes x):
    cdef cython.uchar* arr = <cython.uchar*>PyBytes_AS_STRING(x)
    return (arr[0] << 8) + arr[1]
cpdef  cython.short i16_from_bytes_padded(bytes x):
    cdef         char* arr =                PyBytes_AS_STRING(x)
    return (arr[0] << 8) + arr[1]
cpdef cython.ulong u32_from_bytes_padded(bytes x):
    cdef cython.uchar* arr = <cython.uchar*>PyBytes_AS_STRING(x)
    return (((((arr[0]<<8)+arr[1]) << 8) + arr[2]) << 8) + arr[3]
cpdef  cython.long i32_from_bytes_padded(bytes x):
    cdef         char* arr =                PyBytes_AS_STRING(x)
    return (((((arr[0]<<8)+arr[1]) << 8) + arr[2]) << 8) + arr[3]
cpdef cython.ulonglong u64_from_bytes_padded(bytes x):
    cdef cython.uchar* arr = <cython.uchar*>PyBytes_AS_STRING(x)
    return ((((((((((((((arr[0]<<8)+arr[1])<<8)+arr[2])<<8))+arr[3])<<8)+arr[4])<<8)+arr[5])<<8)+arr[6])<<8)+arr[7]
cpdef  cython.longlong i64_from_bytes_padded(bytes x):
    cdef         char* arr =                PyBytes_AS_STRING(x)
    return ((((((((((((((arr[0]<<8)+arr[1])<<8)+arr[2])<<8))+arr[3])<<8)+arr[4])<<8)+arr[5])<<8)+arr[6])<<8)+arr[7]

# cpdef cython.uchar u8_from_bytes(bytes x): return (<cython.uchar*>PyBytes_AS_STRING(x))[0]
# cpdef         char i8_from_bytes(bytes x): return                 PyBytes_AS_STRING(x) [0]
cpdef cython.ushort u16_from_bytes(bytes x) except? 0:
    cdef cython.uchar l = len(x)
    if l > 2:
        raise ValueError(f"Bytes too large to convert to u16; {l} > 2")
    cdef cython.uchar* arr = <cython.uchar*>PyBytes_AS_STRING(x)
    cdef cython.ushort res = arr[0]
    cdef cython.uchar i
    for i in range(1,l): res = (res << 8) + arr[i]
    return res
cpdef cython.ushort i16_from_bytes(bytes x) except? 0:
    cdef cython.uchar l = len(x)
    if l > 2:
        raise ValueError(f"Bytes too large to convert to i16; {l} > 2")
    cdef cython.char* arr =                 PyBytes_AS_STRING(x)
    cdef cython.ushort res = arr[0]
    cdef cython.uchar i
    for i in range(1,l): res = (res << 8) + arr[i]
    return res
cpdef cython.ulong u32_from_bytes(bytes x) except? 0:
    cdef cython.uchar l = len(x)
    if l > 4:
        raise ValueError(f"Bytes too large to convert to u32; {l} > 4")
    cdef cython.uchar* arr = <cython.uchar*>PyBytes_AS_STRING(x)
    cdef cython.ulong res = arr[0]
    cdef cython.uchar i
    for i in range(1,l): res = (res << 8) + arr[i]
    return res
cpdef cython.long i32_from_bytes(bytes x) except? 0:
    cdef cython.uchar l = len(x)
    if l > 4:
        raise ValueError(f"Bytes too large to convert to i32; {l} > 4")
    cdef cython.char* arr =                 PyBytes_AS_STRING(x)
    cdef cython.long res = arr[0]
    cdef cython.uchar i
    for i in range(1,l): res = (res << 8) + arr[i]
    return res
cpdef cython.ulonglong u64_from_bytes(bytes x) except? 0:
    cdef cython.uchar l = len(x)
    if l > 8:
        raise ValueError(f"Bytes too large to convert to u64; {l} > 8")
    cdef cython.uchar* arr = <cython.uchar*>PyBytes_AS_STRING(x)
    cdef cython.ulonglong res = arr[0]
    cdef cython.uchar i
    for i in range(1,l): res = (res << 8) + arr[i]
    return res
cpdef cython.longlong i64_from_bytes(bytes x) except? 0:
    cdef cython.uchar l = len(x)
    if l > 8:
        raise ValueError(f"Bytes too large to convert to i64; {l} > 8")
    cdef cython.char* arr =                 PyBytes_AS_STRING(x)
    cdef cython.longlong res = arr[0]
    cdef cython.uchar i
    for i in range(1,l): res = (res << 8) + arr[i]
    return res

cpdef PyInt upy_from_bytes(bytes x):
    return int.from_bytes(x, 'big', signed=False)
# cpdef PyInt ipy_from_bytes_slow(bytes x):
#     # cdef array.array arr = array.array('b', x)
#     # cdef char* as_chars = arr.data.as_chars
#     cdef char* arr = PyBytes_AS_STRING(x)
#     cdef cython.uchar i
#     cdef cython.longlong res = arr[0]
#     for i in range(1,len(x)):
#         res = (res << 8) + arr[i]
#     return res
cpdef PyInt ipy_from_bytes(bytes x):
    return int.from_bytes(x, 'big', signed=True)

cpdef str byteify(object bytes, cython.uchar decimals=17):
    # for unit in ("B","KB","MB","GB","TB","PB"): # below is faster
    #     if bytes < 1024:
    #         return f"{bytes:.{decimals}f} {unit}"
    #     bytes /= 1024
    if bytes < 0x400: return f"{bytes:.{decimals}f} B" # 1024
    if bytes < 0x100000: return f"{bytes/0x400:.{decimals}f} KB" # 1024**2 = 1_048_576 = 0x100000
    if bytes < 0x40000000: return f"{bytes/0x100000:.{decimals}f} MB" # 1024**3 = 1_073_741_824 = 0x40000000
    if bytes < 0x10000000000: return f"{bytes/0x40000000:.{decimals}f} GB" # 1024**4 = 1_099_511_627_776 = 0x10000000000
    if bytes < 0x4000000000000: return f"{bytes/0x10000000000:.{decimals}f} TB" # 1024**5 = 1_125_899_906_842_624 = 0x4000000000000
    if bytes < 0x1000000000000000: return f"{bytes/0x4000000000000:.{decimals}f} PB" # 1024**6 = 1_152_921_504_606_846_976 = 0x1000000000000000
    if bytes < 0x400000000000000000: return f"{bytes/0x1000000000000000:.{decimals}f} EB" # 1024**7 = 1_180_591_620_717_411_303_424 = 0x400000000000000000
    if bytes < 0x100000000000000000000: return f"{bytes/0x400000000000000000:.{decimals}f} ZB" # 1024**8 = 1_208_925_819_614_629_174_706_176 = 0x100000000000000000000
    if bytes < 0x40000000000000000000000: return f"{bytes/0x100000000000000000000:.{decimals}f} YB" # 1024**9 = 1_237_940_039_285_380_274_899_124_224 = 0x40000000000000000000000
