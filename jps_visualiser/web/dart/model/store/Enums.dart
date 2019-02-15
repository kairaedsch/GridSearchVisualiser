class Enums
{
  static String toName(dynamic dynamic)
  {
    return dynamic.toString().substring(dynamic.toString().lastIndexOf(".") + 1);
  }
}

enum AlgorithmType
{
  NO_ALGORITHM, DIJKSTRA, A_STAR, JPS, JPSP, JPSP_DATA
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
      case AlgorithmType.JPS: return "JPS";
      case AlgorithmType.JPSP: return "JPS+";
      case AlgorithmType.JPSP_DATA: return "JPS+ Data";
    }
    return "Not Found";
  }

  static String popover = "Select the algorithm to run on the grid";
}

enum HeuristicType
{
  ZERO, CHEBYSHEV, EUCLIDEAN, OCTILE, MANHATTEN
}

class HeuristicTypes
{
  static String getTitle(HeuristicType heuristicType)
  {
    switch (heuristicType)
    {
      case HeuristicType.MANHATTEN: return "Manhattan";
      case HeuristicType.EUCLIDEAN: return "Euclidean";
      case HeuristicType.OCTILE: return "Octile";
      case HeuristicType.CHEBYSHEV: return "Chebyshev";
      case HeuristicType.ZERO: return "Constant Zero";
    }
    return "Not Found";
  }

  static String popover = "Select the heuristic to be used by the algorithm";
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

  static String popover = "Select when the algorithm should run on the grid";
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