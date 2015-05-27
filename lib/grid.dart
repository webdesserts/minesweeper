import 'dart:html';
import 'tile.dart';
import 'row.dart';

class Grid {
  Element node;
  List tiles = [];
  List rows = [];
  num row_count;
  num col_count;

  Grid (Element grid_node, { rows : 10, cols: 10 }) {
    this.node = grid_node;
    this.row_count = rows;
    this.col_count = cols;
    generateGrid();
  }

  generateGrid () {

    for (num r = 0; r < this.row_count; r++) {
      var row = new Row(r);
      this.rows.add(row);
      generateTiles(row);

      this.node.append(row.node);
    }

  }
  generateTiles (Row row) {

    for (num c = 0; c < col_count; c++) {
      var tile = new Tile(row.index, c);
      tiles.add(tile);
      row.node.append(tile.node);
    }

  }

}
