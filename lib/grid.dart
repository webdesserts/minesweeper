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
  String $remaining_tiles;
  ElementStream get onReset => node.on['reset'];
  ElementStream get onArmMines => node.on['armMines'];
  ElementStream get onRevealed => node.on['revealed'];
  ElementStream get onDisable => node.on['disable'];
  ElementStream get onEnable => node.on['enable'];
  ElementStream get onSelect => node.on['select'];

  Grid({
    this.rows: 10,
    this.cols: 10,
    this.$tiles: '.tile',
    this.$rows: '.row',
    this.$remaining_tiles: '.tile:not(.revealed):not(.mine)'
  });

  initialize() {
    generateGrid(this.rows, this.cols);
    var tile = new Component(() => new Tile());
    tile.attachTo($tiles);
    onReset.listen(reset);
    onArmMines.listen(armMines);
    onRevealed.listen(cascadeReveal);
    onRevealed.listen(countRemainingMines);
    setupEvents();
  }

  /// any of the listeners that need to be set up at the beginning of each game;
  setupEvents() {
    onDisable.first.then(disableAllTiles);
    onEnable.first.then(enableAllTiles);
    onSelect.first.then((event) => dispatch(new CustomEvent('selected', detail: event.detail )));
  }

  /// set mines randomly throughout the field without setting it on the starting tile
  armMines (CustomEvent event) {
    int mine_count = event.detail['mines'];
    Element start_tile = event.detail['startTile'];

    ElementList tiles = querySelectorAll($tiles);

    var start_index = tiles.indexOf(start_tile);
    num tile_count = tiles.length;
    var randomizer = new Random();
    List chosen = [];

    for (var i = 0; i < mine_count; i++) {
      int random_index = randomizer.nextInt(tile_count);
      while (random_index == start_index || chosen.contains(random_index)) {
        print('trying to get lucky');
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

  countRemainingMines (CustomEvent event) {
    ElementList remaining = querySelectorAll($remaining_tiles);
    print(remaining.length);
    if (remaining.length == 0) trigger('complete');
  }

  /// reveals everything next to an empty tile.
  cascadeReveal (CustomEvent event) {
    if (event.detail != null && event.detail.isEmpty ) {
      print('cascade');
      List neighbors = findNeighbors(event.target);

      for (var neighbor in neighbors) {
        var timer = new Timer(new Duration(milliseconds: 100), () {
          neighbor.dispatchEvent(new CustomEvent('cascadeReveal'));
        });

        neighbor.on['cascadeReveal'].first.then((_) => timer.cancel());
      }
    }
  }

  /// let the user click things!
  enableAllTiles (CustomEvent event) {
    print('enabling grid');
    if (event.target == node) {
      triggerOnAll($tiles, 'enable');
    }
  }

  /// prevent everything from being selectable
  disableAllTiles (CustomEvent event) {
    print('enabling grid');
    if (event.target == node) {
      triggerOnAll($tiles, 'disable');
    }
  }

  /// clear the grid
  reset (event) {
    if (event.target == node) {
      triggerOnAll($tiles, 'reset');
      setupEvents();
    }
  }

  /// search for adjacent tiles
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

  /// find tiles to the left and right of a tile
  collectSiblings (Element ele) {
    List<Element> siblings = [];
    if (ele.nextElementSibling != null) siblings.add(ele.nextElementSibling);
    if (ele.previousElementSibling != null) siblings.add(ele.previousElementSibling);
    return siblings;
  }

  /// initial grid setup generation
  /// sets up the rows and
  // TODO: set this up somewhere else
  generateGrid(num rows, num cols) {
    for (num r = 0; r < rows; r++) {
      var row = new DivElement();
      row.className = "row";
      generateTiles(row, cols);
      node.append(row);
    }
  }

  /// add all the tiles to each row
  generateTiles(Element row, num cols) {
    for (num c = 0; c < cols; c++) {
      var tile = new DivElement();
      tile.className = "tile";
      row.append(tile);
    }
  }
}