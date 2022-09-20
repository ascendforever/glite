


cimport cython
from cpython cimport int as PyInt



cpdef bint isnone(object obj)

cpdef object filter_not_none(object iterable)
cpdef object filter_type(object type, object iterable)
cpdef bint anymap(object func, object iterable)
cpdef bint allmap(object func, object iterable)
cpdef bint anynone(object iterable)
cpdef bint allnone(object iterable)

cpdef void exhaust(object it)


cpdef object enumerate1(object iterable)


cpdef str padded_hex(object val, cython.uchar pad_size=*)


cpdef str natural_commas(object texts, str delimiter=*)

cpdef cython.uint lenlongestfrom(object iterable)


cpdef object exc_tb_lines(object etype, object exc, object tb, object limit=*, cython.bint chain=*)
cpdef object exc_tb_lines_lazy(object exception, object limit=*, cython.bint chain=*)



cpdef bint empty_range(PyInt start, PyInt stop, PyInt step=*)
# cpdef PyInt len_range_pyint(PyInt start, PyInt stop, PyInt step=*)
cpdef PyInt len_range(PyInt start, PyInt stop, PyInt step=*)
# cpdef PyInt last_of_range_pyint(PyInt start, PyInt stop, PyInt step=*)
cpdef PyInt last_of_range(PyInt start, PyInt stop, PyInt step=*)

cpdef bint implements__hash__(object obj)










