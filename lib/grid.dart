library Grid;

import 'component.dart';
import 'tile.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';

class Grid extends ComponentHandler {

  num cols;
  num rows;
  String $tiles;
  String $rows;
  ElementStream get onReset => node.on['reset'];
  ElementStream get onArmMines => node.on['armMines'];
  ElementStream get onReveal => node.on['reveal'];

  Grid({
    this.rows: 10,
    this.cols: 10,
    this.$tiles: '.tile',
    this.$rows: '.row'
  });

  initialize() {
    generateGrid(this.rows, this.cols);
    var tile = new Component(() => new Tile());
    tile.attachTo($tiles);
    onReset.listen(reset);
    onArmMines.listen(armMines);
    onReveal.listen(cascadeReveal);
  }

  reset (event) {
    if (event.target == node) {
      triggerOnAll($tiles, 'reset');
      print('reseting grid');
    }
  }

  armMines (CustomEvent event) {
    var mine_count = event.detail.mines;

    ElementList tiles = querySelectorAll($tiles);
    num tile_count = tiles.length;
    var randomizer = new Random();
    List chosen = [];

    for (var i = 0; i < mine_count; i++) {
      int random_index = randomizer.nextInt(tile_count);
      while (chosen.contains(random_index)) {
        random_index = randomizer.nextInt(tile_count);
      }
      chosen.add(random_index);
      Element random_tile = tiles[random_index];
      random_tile.dispatchEvent(new CustomEvent('armMine'));
      var neighbors = findNeighbors(random_tile);
      for (var neighbor in neighbors) {
        neighbor.dispatchEvent(new CustomEvent('nearMine'));
      }
    }
  }

  cascadeReveal (CustomEvent event) {
    List neighbors = findNeighbors(event.target);
    if (event.detail != null && !event.detail.isMine && event.detail.nearbyMines == 0 ) {
      for (var neighbor in neighbors) {
        var timer = new Timer(new Duration(milliseconds: 100), () {
          neighbor.dispatchEvent(new CustomEvent('cascadeReveal'));
        });
        neighbor.on['reveal'].first.then((_)=> timer.cancel());
      }
    }
  }

  findNeighbors (Element tile) {
    List<Element> neighbors = [];
    Element row = tile.parent;
    int index = row.children.indexOf(tile);

    neighbors.addAll(collectSiblings(tile));

    List<Element> adjacent_rows = collectSiblings(row);
    for (var adjacent_row in adjacent_rows) {
      Element vertical_tile = adjacent_row.children.elementAt(index);
      neighbors.add(vertical_tile);
      neighbors.addAll(collectSiblings(vertical_tile));
    }
    return neighbors;
  }

  collectSiblings (Element ele) {
    List<Element> siblings = [];
    if (ele.nextElementSibling != null) siblings.add(ele.nextElementSibling);
    if (ele.previousElementSibling != null) siblings.add(ele.previousElementSibling);
    return siblings;
  }

  generateGrid(num rows, num cols) {
    for (num r = 0; r < rows; r++) {
      var row = new DivElement();
      row.className = "row";
      generateTiles(row, cols);
      node.append(row);
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