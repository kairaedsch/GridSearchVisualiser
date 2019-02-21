class Enums
{
  static String toName(dynamic dynamic)
  {
    return dynamic.toString().substring(dynamic.toString().lastIndexOf(".") + 1);
  }
}

enum AlgorithmType
{
  NO_ALGORITHM, DIJKSTRA, A_STAR, DJPS, DJPS_LU, DJPS_PC
}

class AlgorithmTypes
{
  static String getTitle(AlgorithmType algorithmType)
  {
    switch (algorithmType)
    {
      case AlgorithmType.NO_ALGORITHM: return "None";
      case AlgorithmType.DIJKSTRA: return "Dijkstra";
      case AlgorithmType.A_STAR: return "A*";
      case AlgorithmType.DJPS: return "DJPS";
      case AlgorithmType.DJPS_LU: return "DJPS Lookup";
      case AlgorithmType.DJPS_PC: return "DJPS Pre-Calculation";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select the algorithm to run on the grid</div>
            <div class="options">
              <div class='title'>None</div>
              <div class='content'>
                No algorithm will run on the grid.
              </div>
              <div class='title'>Dijkstra</div>
              <div class='content'>
                The Dijksra Pathfinding Algorithm.
              </div>
              <div class='title'>A*</div>
              <div class='content'>
                The A* Pathfinding Algorithm.
              </div>
              <div class='title'>DJPS</div>
              <div class='content'>
                The Directed Jump Point Search Algorithm.
              </div>
              <div class='title'>DJPS Lookup</div>
              <div class='content'>
                The Directed Jump Point Search Lookup Algorithm using pre-calculated lookup data.
              </div>
              <div class='title'>DJPS Pre-Calculation</div>
              <div class='content'>
                The Directed Jump Point Search Pre-Calculation Algorithm using backwards pre-calculation.
              </div>
            </div>
            """;
}

enum HeuristicType
{
  ZERO, CHEBYSHEV, EUCLIDEAN, OCTILE, MANHATTAN
}

class HeuristicTypes
{
  static String getTitle(HeuristicType heuristicType)
  {
    switch (heuristicType)
    {
      case HeuristicType.MANHATTAN: return "Manhattan";
      case HeuristicType.EUCLIDEAN: return "Euclidean";
      case HeuristicType.OCTILE: return "Octile";
      case HeuristicType.CHEBYSHEV: return "Chebyshev";
      case HeuristicType.ZERO: return "Constant Zero";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select the heuristic to be used by the algorithm</div>
            <div class="options">
              <div class='title'>Constant Zero</div>
              <div class='content'>
                A heuristic which always returns 0.
              </div>
              <div class='title'>Chebyshev</div>
              <div class='content'>
                The Chebyshev distance is calculated by the moves a chess king would have to make.
              </div>
              <div class='title'>Euclidean</div>
              <div class='content'>
                The Euclidean distance is calculated by the length of the air line.
              </div>
              <div class='title'>Octile</div>
              <div class='content'>
                The octile distance is calculated by the length of the octile path.
              </div>
              <div class='title'>Manhattan</div>
              <div class='content'>
                The Manhattan distance is calculated by summing the difference of the x and the y coordinates.
              </div>
            </div>
            """;
}

enum AlgorithmUpdateMode
{
  DURING_EDITING, AFTER_EDITING, MANUALLY
}

class AlgorithmUpdateModes
{
  static String getTitle(AlgorithmUpdateMode algorithmUpdateMode)
  {
    switch (algorithmUpdateMode)
    {
      case AlgorithmUpdateMode.DURING_EDITING: return "During editing";
      case AlgorithmUpdateMode.AFTER_EDITING: return "After editing";
      case AlgorithmUpdateMode.MANUALLY: return "Manually";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select when the algorithm should run on the grid</div>
            <div class="options">
              <div class='title'>During editing</div>
              <div class='content'>
                The algorithm runs while you change something in the grid.
              </div>
              <div class='title'>After editing</div>
              <div class='content'>
                The algorithm runs after you changed something in the grid.
              </div>
              <div class='title'>Manually</div>
              <div class='content'>
                The algorithm runs when you click on the play button.
              </div>
            </div>
            """;
}

enum GridMode
{
  BASIC, ADVANCED
}

class GridModes
{
  static String getTitle(GridMode gridmode)
  {
    switch (gridmode)
    {
      case GridMode.BASIC: return "Basic";
      case GridMode.ADVANCED: return "Advanced";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select the mode of the grid</div>
            <div class="options">
              <div class='title'>Basic</div>
              <div class='content'>
                Nodes can either be marked as walkable or as not walkable.
              </div>
              <div class='title'>Advanced</div>
              <div class='content'>
                For each direction a node can be marked as enterable or as not enterable.
              </div>
            </div>
            """;
}

enum DirectionMode
{
  ALL, ONLY_CARDINAL, ONLY_DIAGONAL
}

class DirectionModes
{
  static String getTitle(DirectionMode directionMode)
  {
    switch (directionMode)
    {
      case DirectionMode.ALL: return "All";
      case DirectionMode.ONLY_CARDINAL: return "Only cardinal";
      case DirectionMode.ONLY_DIAGONAL: return "Only diagonal";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select which directions are allowed</div>
            <div class="options">
              <div class='title'>All</div>
              <div class='content'>
                All 8 directions.
              </div>
              <div class='title'>Only cardinal</div>
              <div class='content'>
                Nort, east, south and west.
              </div>
              <div class='title'>Only diagonal</div>
              <div class='content'>
                Northeast, southeast, southwest and northwest.
              </div>
            </div>
            """;
}

enum DirectionalMode
{
  MONO, BI
}

class DirectionalModes
{
  static String getTitle(DirectionalMode directionalMode)
  {
    switch (directionalMode)
    {
      case DirectionalMode.MONO: return "Mono";
      case DirectionalMode.BI: return "Bi";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select the directional mode</div>
            <div class="options">
              <div class='title'>Mono</div>
              <div class='content'>
                You can have one-way connections between nodes.
              </div>
              <div class='title'>Bi</div>
              <div class='content'>
                You can <strong>not</strong> have one-way connections between nodes.
              </div>
            </div>
            """;
}

enum CornerMode
{
  CROSS, BYPASS
}

class CornerModes
{
  static String getTitle(CornerMode cornerMode)
  {
    switch (cornerMode)
    {
      case CornerMode.CROSS: return "Cross";
      case CornerMode.BYPASS: return "Bypass";
    }
    return "Not Found";
  }

  static String popover = """
            <div class="title">Select how corners are handled</div>
            <div class="options">
              <div class='title'>Cross</div>
              <div class='content'>
                Edges are allowed to cross blocked corners.
              </div>
              <div class='title'>Bypass</div>
              <div class='content'>
                Eges are not allowed to cross blocked corners.
              </div>
            </div>
            """;
}