library Game;

import 'package:minesweeper/component.dart';
import 'package:minesweeper/grid.dart';
import 'dart:html';

class Game extends ComponentHandler {

  initialize () {
    generateGrid(node.querySelector('#grid'));
    var grid = new Component(() => new Grid());
    grid.attachTo('#grid');
  }

  generateGrid(Element grid, { rows: 10, cols: 10 }) {

    for (num r = 0; r < rows; r++) {
      var row = new DivElement();
      row.className = "row";
      generateTiles(row, cols);
      grid.append(row);
    }
  }

  generateTiles(Element row, num cols) {
    for (num c = 0; c < cols; c++) {
      var tile = new DivElement();
      tile.className = "tile";
      row.append(tile);
    }
  }
}