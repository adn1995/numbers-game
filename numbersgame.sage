# filename: numbersgame.sage
# author: Arthur Diep-Nguyen

"""Numbers game on Coxeter graphs.

This module implements functions from the "numbers game" from Section
4.3 from The Combinatorics of Coxeter Groups by Bjorner and Brenti.

Here, we implement only the "chambers" version of the game, not the
"roots" version. Furthermore, we assume that the specified Coxeter group
is locally simply-laced.
"""

def fire_node(cox_mtx, fired_node, position):
    """Fires the specified node.

    Given a `position` of the (chambers) game and a node to be fired,
    this function returns the result of firing this node.

    Parameters
    ----------
    cox_mtx: CoxeterMatrix
    fired_node: Integer
        Non-negative integer representing a vertex of the Coxeter graph
        represented by `coxeter_matrix`.
    position: tuple[Integer]
        Tuple of integers representing the current position of the
        numbers game.

    Returns
    -------
    tuple[Integer]

    Examples
    --------

    sage: M = CoxeterMatrix([[1,3,3,3],[3,1,3,3],[3,3,1,3],[3,3,3,1]])
    sage: unit_position = (1,1,1,1)
    sage: fire_node(M,2,unit_position)
    (2, 2, -1, 2)
    """
    M = matrix(cox_mtx)
    rank = M.nrows()
    nodes = list(range(rank))
    if fired_node not in nodes:
        raise Exception("The fired node is not in the vertex set of the "
            "Coxeter graph")
    elif len(position) != rank:
        raise Exception("The position does not match the size of the vertex "
            "set")
    new_position = list(position)
    for index in range(rank):
        entry = M[fired_node, index]
        #######################################################################
        # Not sure why I keep getting an error here...
        # I'll just use if-else for now...
        #######################################################################
        # if entry < -1:
        #    entry = -1
        # match entry:
        #     case 1 | 2: # not a neighbor in Coxeter graph
        #         continue
        #     case 3: # neighbor in Coxeter graph with braid relation of length 3
        #         new_position[index] += position[fired_node]
        #     case -1: # neighbor with no braid relation
        #         new_position[index] += 2 * position[fired_node]
        #     case Integer(): # braid relation is wrong length
        #         raise Exception("Coxeter group is not locally simply-laced")
        #     case _:
        #         raise Exception("Inputted matrix is not a Coxeter matrix")
        #######################################################################
        if entry in (1,2): # not a neighbor in Coxeter graph
            continue
        elif entry == 3: # neighbor with braid relation of length 3
            new_position[index] += position[fired_node]
        elif entry <= -1:
            new_position[index] += 2 * position[fired_node]
        elif entry > 3:
            raise Exception("Coxeter group is not locally simply-laced")
        else:
            raise Exception("Inputted matrix is not a Coxeter matrix")
    new_position[fired_node] = -position[fired_node]
    return tuple(new_position)

def fire_sequence(coxeter_matrix, fired_sequence, position):
    """Fires a sequence of nodes.

    Given a `position` of the (chambers) game and a list of nodes to be
    fired, this function returns the result of firing this sequence.

    Parameters
    ----------
    coxeter_matrix: CoxeterMatrix
    fired_sequence: list[Integer]
        List of non-negative integers representing vertices of the
        Coxeter graph represented by `coxeter_matrix`.
    position: tuple[Integer]
        Tuple of integers representing the current position of the
        numbers game.

    Returns
    -------
    tuple[Integer]

    Examples
    --------

    sage: M = CoxeterMatrix([[1,3,3,3],[3,1,3,3],[3,3,1,3],[3,3,3,1]])
    sage: unit_position = (1,1,1,1)
    sage: fire_sequence(M,2,unit_position)
    (2, 2, -1, 2)
    sage: fire_sequence(M,[],unit_position)
    (1, 1, 1, 1)
    sage: fire_sequence(M,[0,2,3],unit_position)
    (5, 8, 2, -4)
    """
    match fired_sequence:
        case Integer():
            return fire_node(coxeter_matrix, fired_sequence, position)
        case []:
            return position
        case [fired_node]:
            return fire_node(coxeter_matrix, fired_node, position)
        case list():
            new_position = position
            for fired_node in fired_sequence:
                new_position = fire_node(coxeter_matrix, fired_node, new_position)
            return new_position
        case _:
            raise Exception("Sequence is not a list")
