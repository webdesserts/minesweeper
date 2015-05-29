library Grid;

import 'component.dart';
import 'tile.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';

class Grid extends ComponentHandler {

  int cols;
  int rows;
  String $tiles;
  String $rows;
  ElementStream get onReset => node.on['reset'];
  ElementStream get onArmMines => node.on['armMines'];
  ElementStream get onRevealed => node.on['revealed'];
  ElementStream get onDisable => node.on['disable'];

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
    onRevealed.listen(cascadeReveal);
    onDisable.first.then(disableAllTiles);
  }

  reset (event) {
    if (event.target == node) {
      triggerOnAll($tiles, 'reset');
      onDisable.first.then(disableAllTiles);
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
    if (event.detail != null && event.detail.isEmpty ) {
      List neighbors = findNeighbors(event.target);

      for (var neighbor in neighbors) {
        var timer = new Timer(new Duration(milliseconds: 100), () {
          neighbor.dispatchEvent(new CustomEvent('cascadeReveal'));
        });

        neighbor.on['cascadeReveal'].first.then((_) => timer.cancel());
      }

    }
  }

  disableAllTiles (CustomEvent event) {
    triggerOnAll($tiles, 'disable');
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