# filename: hyperbolicspace.sage
# author: Arthur Diep-Nguyen

"""Converting points between models of hyperbolic 3-space.

The purpose of this module is to take points in R^4 lying on one sheet
of a two-sheeted hyperboloid, then transform these points into the a
model of hyperbolic 3-space that we can visualize.

An arbitrarily oriented hyperboloid centered at v is defined by the
equation
    (x-v)^T * A * (x-v) = 1
for some matrix A.

The eigenvectors of A define the principal directions of the
hyperboloid, and the eigenvalues of A are the reciprocals of the squares
of the semi-axes. If there is exactly one positive eigenvalue (all the
others being negative), then the hyperboloid is two-sheeted.
#TODO: might want to provide a reasonable reference for this fact

Suppose we had points lying on the positive sheet of a two-sheeted
hyperboloid in R^4. This hyperboloid can be seen as a model of
hyperbolic 3-space. With a change-of-basis for R^4, we can write this
hyperboloid as the standard Minkowski hyperboloid model for hyperbolic
3-space.

From here, we can convert to other models of hyperbolic 3-space, such as
the Poincare ball or Klein ball. With these models, we can visualize
our points in R^3.
"""

def is_2sheethyperboloid(mtx):
    """Checks if the matrix defines a two-sheeted hyperboloid in R^4.

    Parameters
    ----------
    mtx: Matrix

    Returns
    -------
    bool

    Examples
    --------

    sage: is_2sheethyperboloid(identity_matrix(4))
    False
    sage: M = matrix([[0,1/12,1/12,1/12],[1/12,0,1/12,1/12],
    ....: [1/12,1/12,0,1/12],[1/12,1/12,1/12,0]])
    sage: is_2sheethyperboloid(M)
    True
    """
    #if (type(mtx) != sage.matrix.matrix_generic_sparse.Matrix_generic_sparse
    #    or type(mtx) != sage.matrix.matrix_integer_dense.Matrix_integer_dense):
    #    raise TypeError("Not a matrix")
    if mtx.nrows() != 4:
        raise ValueError("Not 4-dimensional")
    signature = [sign(eigenvalue) for eigenvalue in mtx.eigenvalues()]
    return signature.count(1) == 1 and signature.count(-1) == 3

def is_in_hyperboloid(pt,mtx,center):
    """Checks if the point lies on the hyperboloid.

    An arbitrarily oriented hyperboloid centered at v is defined
    by the equation
        (x-v)^T * A * (x-v) == 1
    for some matrix A.

    This function checks if `pt` lies on the hyperboloid defined by the
    matrix `mtx` and centered at `center`.

    Parameters
    ----------
    pt: Vector
    mtx: Matrix
    center: Vector

    Returns
    -------
    bool

    Examples
    --------

    sage: M = matrix([[0,1/12,1/12,1/12],[1/12,0,1/12,1/12],
    ....: [1/12,1/12,0,1/12],[1/12,1/12,1/12,0]])
    sage: pt = vector([1,1,1,1])
    sage: center = vector([0,0,0,0])
    sage: is_in_hyperboloid(pt,M,center)
    True
    """
    return (pt-center) * mtx * (pt-center) == 1

def hyp_to_minkowski(pt,mtx,center):
    """Converts from arbitrary hyperboloid to Minkowski hyperboloid.

    Recall that in R^4, the standard Minkowski hyperboloid is given by
        x^T * A * x == 1
    where A is the 4x4 matrix
        [  1  0  0  0]
        [  0 -1  0  0]
        [  0  0 -1  0]
        [  0  0  0 -1]

    Given a 2-sheeted hyperboloid in R^4, we can perform a
    change-of-basis to transform it into the Minkowski hyperboloid.

    This function takes a point and returns its image after this
    change of basis.

    Parameters
    ----------
    pt: Vector
    mtx: Matrix
    center: Vector

    Returns
    -------
    Vector

    Examples
    --------
    #TODO
    """
    if not is_2sheethyperboloid(mtx):
        raise ValueError("Matrix does not define two-sheeted hyperboloid")
    pass #TODO I will write this function later

def minkowski_to_klein(pt):
    """Converts from the Minkowski hyperboloid to the Klein ball.

    Parameters
    ----------
    pt: Vector

    Returns
    -------
    Vector

    Examples
    --------
    #TODO
    """
    coords = list(pt)[1:]
    klein_pt = [coord/pt[0] for coord in coords]
    return vector(klein_pt)

def klein_to_minkowski(pt):
    """Converts from the Klein ball to the Minkowski hyperboloid.

    Parameters
    ----------
    pt: Vector

    Returns
    -------
    Vector

    Examples
    --------
    #TODO
    """
    coords = list(pt)
    scale = 1 - sum(coords)
    coords.insert(0,1)
    new_pt = [coord/scale for coord in coords]
    return vector(new_pt)
