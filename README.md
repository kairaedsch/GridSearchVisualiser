<p align="center">
  <a href="https://kairaedsch.github.io/GridSearchVisualiser/">
    <img width="80%" src="images/logo.gif"/>
  </a>
</p>
<p align="center">
  <a href="https://kairaedsch.github.io/GridSearchVisualiser/">
    <img src="https://img.shields.io/github/workflow/status/kairaedsch/GridSearchVisualiser/Test,%20Build,%20Deploy%20and%20Release/master?label=master%20-%20build&style=flat-square"/>
  </a>
  <a href="https://kairaedsch.github.io/GridSearchVisualiser/develop">
    <img src="https://img.shields.io/github/workflow/status/kairaedsch/GridSearchVisualiser/Test,%20Build,%20Deploy%20and%20Release/master?label=develop%20-%20build&style=flat-square"/>
  </a>
  <a href="https://github.com/kairaedsch/GridSearchVisualiser/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/kairaedsch/GridSearchVisualiser?style=flat-square"/>
  </a>
</p>

<h1 align="center">Grid Search Visualiser</h1>

A online algorithm visualiser for pathfinding algorithms.

The tool was created for my bachelor thesis "Jump Point Search on Directed Grids" at the University of Passau.

## How to use
The tool can be used at [kairaedsch.github.io/GridSearchVisualiser](https://kairaedsch.github.io/GridSearchVisualiser/).

<p align="center">
  <a href="https://kairaedsch.github.io/GridSearchVisualiser/">
    <img width="100%" src="images/intro.gif"/>
  </a>
</p>

## Features

### 📈 Supported Grids
Two grid modes are supported with additional options:

| Grid Mode Blockwise | Grid Mode Edgewise |
| ------------------- | - |
| <img src="images/grid-blockwise.png"/> | <img src="images/grid-edgewise.png"/> |
| In this mode, each node can be blocked. | In this mode, each edge can be blocked per direction. |
| <img src="images/grid-blockwise-cross-corners.png"/> | <img src="images/grid-edgewise-detail.png"/> |
| **+ option** crossing corners allowed. | Each blue object blocks a direction. |
| <img src="images/grid-blockwise-cardinal-only.png"/> | |
| **+ option** cardinal paths only. | |

### 🤖 Supported Algorithms
| Algorithm                | Description |
| ------------------------ | - |
| **Dijkstra**             | The Dijkstra Pathﬁnding Algorithm |
| **A\***                  | The A* Pathﬁnding Algorithm |
| **DJPS**                 | The Directed Jump Point Search Algorithm (alternative Version) |
| **DJPS Lookup**          | The Directed Jump Point Search Lookup Algorithm using pre-calculated lookup data |
| **DJPS Pre-Calculation** | The Directed Jump Point Search Pre-Calculation Algorithm using backwards pre-calculation |

### 📐 Supported Heuristics
| Heuristics    | Description |
| ------------- | - |
| **Chebyshev** | The Chebyshev distance as heuristic. This distance is calculated by the moves a chess king would have to make. |
| **Euclidean** | The Euclidean distance as heuristic. This distance is calculated as the crow ﬂies. |
| **Octile**    | The octile distance as heuristic. This distance is calculated by the length of the octile path. |
| **Manhattan** | The Manhattan distance as heuristic. This distance is calculated by summing the diﬀerence of the x and the y coordinates.  |

## Built With
* [Dart](https://dart.dev/) - Programming language
* [Dart pub](https://pub.dev/) - Dependency Management
* [OverReact](https://github.com/Workiva/over_react) - React JS for Dart

## Authors
* **Kai Rädsch** - *Initial work* - [kairaedsch](https://github.com/kairaedsch)

## License
This project is licensed under the GNU General Public License - see the [LICENSE](LICENSE) file for details
