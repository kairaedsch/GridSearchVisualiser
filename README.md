# JPS Visualiser

## Create a Grid
- Creation of a grid with a start-node, end-node and barrier
- 2 accuracys
    - Blockwise
        - Settings
            - Allow Diagonal
            - Cross Corners
    - edgewise

## Run an Algorithm
- 3 available algorithms
    - Dijkstra
    - A*
    - JPS
- Settings
    - Heuristic
        - Manhattan
        - Euclidean
        - Octile
        - Chebyshev

## Visualise the Steps
- General 
    - Data per node
        - Marking status
            - Unmarked
            - Open
            - Closed
        - Parent
        - Ranking
        - Active
    - Steps
        - Choose active node
        - Mark active node as closed
        - Add new nodes to the open list and update values of nodes
            - Show each node which changed and how

- JPS
    - Data per node
        - Jump Points
