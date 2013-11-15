import 'package:angular/angular.dart';
import 'dart:math';

@NgController(
    selector: '[life]',
    publishAs: 'ctrl')
class LifeController {

  List<List<Cell>> grid;
  
  LifeController() {
    var rnd = new Random();
    
    grid = new List<List<Cell>>();
    
    var numRows = 10;
    var numCols = 10;
    for (var y = 0; y < numRows; y++)
    {
      var row = new List<Cell>();
      grid.add(row);
      
      for (var x = 0; x < numCols; x++)
      {
        var id = y * numCols + x;
        row.add(new Cell(id, rnd.nextBool()));
      }
    }
  }
}


class Cell {
  int id;
  bool visible;
  
  Cell(this.id, this.visible);
}


class MyAppModule extends Module {
  MyAppModule() {
    type(LifeController);
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}
