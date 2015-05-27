library Grid;

import 'component.dart';
import 'row.dart';
import 'tile.dart';

class Grid extends ComponentHandler {

  String $tiles;
  String $rows;

  Grid({
    this.$tiles: '.tile',
    this.$rows: '.row'
  });

  initialize() {
    var row = new Component(() => new Row());
    var tile = new Component(() => new Tile());
    row.attachTo($rows);
    tile.attachTo($tiles);
  }

}