
from glite.__static.__cimports cimport *

ctypedef fused int_any:
    cython.ushort
    cython.uint
    cython.ulong
    cython.ulonglong
    cython.short
    cython.int
    cython.long
    cython.longlong

ctypedef fused u8_or_i8:
    cython.char
    cython.uchar
ctypedef fused u16_or_i16:
    cython.long
    cython.ulong
ctypedef fused u32_or_i32:
    cython.long
    cython.ulong
ctypedef fused u64_or_i64:
    cython.longlong
    cython.ulonglong

cdef bytes  any8_to_bytes(u8_or_i8 x)
cdef bytes any16_to_bytes(u16_or_i16 x)
cdef bytes any32_to_bytes(u32_or_i32 x)
cdef bytes any64_to_bytes(u64_or_i64 x)


cdef cython.uint _upy_size(PyInt x)
cdef cython.uint _ipy_size(PyInt x)
cpdef cython.uint upy_size(PyInt x)
cpdef cython.uint ipy_size(PyInt x)

cpdef bytes upy_to_bytes(PyInt x)
cpdef bytes ipy_to_bytes(PyInt x)
cpdef bytes  u8_to_bytes(cython.uchar x)
cpdef bytes  i8_to_bytes( cython.char x)
cpdef bytes u16_to_bytes(cython.ushort x)
cpdef bytes i16_to_bytes( cython.short x)
cpdef bytes u32_to_bytes(cython.ulong x)
cpdef bytes i32_to_bytes( cython.long x)
cpdef bytes u64_to_bytes(cython.ulonglong x)
cpdef bytes i64_to_bytes( cython.longlong x)

cpdef cython.ushort u16_from_bytes_padded(bytes x)
cpdef  cython.short i16_from_bytes_padded(bytes x)
cpdef cython.ulong u32_from_bytes_padded(bytes x)
cpdef  cython.long i32_from_bytes_padded(bytes x)
cpdef cython.ulonglong u64_from_bytes_padded(bytes x)
cpdef  cython.longlong i64_from_bytes_padded(bytes x)

# cpdef cython.uchar u8_from_bytes(bytes x)
# cpdef         char i8_from_bytes(bytes x)
cpdef cython.ushort u16_from_bytes(bytes x) except? 0
cpdef cython.ushort i16_from_bytes(bytes x) except? 0
cpdef cython.ulong u32_from_bytes(bytes x) except? 0
cpdef cython.long i32_from_bytes(bytes x) except? 0
cpdef cython.ulonglong u64_from_bytes(bytes x) except? 0
cpdef cython.longlong i64_from_bytes(bytes x) except? 0
cpdef PyInt upy_from_bytes(bytes x)
cpdef PyInt ipy_from_bytes(bytes x)

cpdef str byteify(object bytes, cython.uchar decimals=*)
