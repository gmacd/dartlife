import 'package:angular/angular.dart';

@NgController(
    selector: '[life-grid]',
    publishAs: 'ctrl')
class LifeController {

  List<bool> grid;

  LifeController() {
    grid = [0,0,0,1,0,1,0,0,0];
  }

}

class MyAppModule extends Module {
  MyAppModule() {
    type(LifeController);
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}
