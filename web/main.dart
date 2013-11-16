import 'package:angular/angular.dart';
import 'dart:math';
import 'dart:async';

@NgController(
    selector: '[life]',
    publishAs: 'ctrl')
class LifeController {

  final numRows = 30;
  final numCols = 30;

  List<List<Cell>> grid;
  List<List<Cell>> nextGrid;

  bool paused = true;


  LifeController() {
    randomizeGrid();

    var timer = new Timer.periodic(new Duration(milliseconds: 100), updateCells);
  }

  updateCells(timer) {
    if (paused)
      return;

    for (var y = 0; y < numRows; y++) {
      for (var x = 0; x < numCols; x++) {
        var numNeighbours = numNeighbours(grid, x, y);
        var wasAlive = getCell(grid, x, y).alive;

        var isAlive =
            (wasAlive && ((numNeighbours == 2) || (numNeighbours == 3)))
            || (!wasAlive && (numNeighbours == 3));

        getCell(nextGrid, x, y).alive = isAlive;
      }
    }

    switchGrids();
  }

  Cell getCell(g, x, y) {
    return g[y][x];
  }

  int numNeighbours(List<List<Cell>> g, x, y) {
    var left = x-1;
    var right = x+1;
    var above = y-1;
    var below = y+1;

    // Wrap around edges
    if (left < 0) left = numCols-1;
    if (right >= numCols) right = 0;
    if (above < 0) above = numRows-1;
    if (below >= numRows) below = 0;

    var liveStates =
        [g[above][left].alive,
         g[above][x].alive,
         g[above][right].alive,
         g[y][left].alive,
         g[y][right].alive,
         g[below][left].alive,
         g[below][x].alive,
         g[below][right].alive];
    return liveStates.fold(0, (sum, live) => sum + (live ? 1 : 0));
  }

  List<List<Cell>> generateRandomGrid(seed) {
    var rnd = new Random(seed);
    return new List<List<Cell>>.generate(numRows,
        (int rowIdx) => new List<Cell>.generate(numCols,
            (int colIdx) => new Cell(rowIdx * numCols + colIdx, rnd.nextBool())));
  }

  // Change current grid, copy over previous
  switchGrids() {
    var tmpGrid = grid;
    grid = nextGrid;
    nextGrid = tmpGrid;

    for (var y = 0; y < numRows; y++) {
      for (var x = 0; x < numCols; x++) {
        nextGrid[y][x].alive = grid[y][x].alive;
      }
    }
  }

  togglePause() { paused = !paused; }

  clear() {
    for (var y = 0; y < numRows; y++) {
      for (var x = 0; x < numCols; x++) {
        grid[y][x].alive = false;
        nextGrid[y][x].alive = false;
      }
    }
  }

  randomizeGrid() {
    var seed = new Random().nextInt(100000);
    grid = generateRandomGrid(seed);
    nextGrid = generateRandomGrid(seed);
  }
}


class Cell {
  int id;
  bool alive;

  Cell(this.id, this.alive);

  toggle() { alive = !alive; }
}


class MyAppModule extends Module {
  MyAppModule() {
    type(LifeController);
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}
