library Game;

import 'dart:html';
import 'dart:math';

import 'grid.dart';
import 'component.dart';

class Game extends ComponentHandler {

  String $restart;
  String $grid;
  String $mines;
  num score;
  num mines;
  int size;

  ElementStream get onStart => node.on['start'];
  ElementStream get onTrippedMine => node.on['trippedMine'];

  Game({
    this.mines: 100,
    this.size: 60,
    this.$restart: '.restart',
    this.$grid: '#grid',
    this.$mines: '.tile.mine'
  });

  initialize () {
    var grid = new Component(() => new Grid(rows: sqrt(size).round(), cols: sqrt(size).round()));
    grid.attachTo($grid);

    querySelectorAll($restart).onClick.listen(restart);
    onStart.listen(start);
    onTrippedMine.first.then(gameOver);
    trigger('start');
  }

  restart (event) {
    triggerOn($grid, 'reset');
    node.classes.remove('over');
    onTrippedMine.first.then(gameOver);
    trigger('start');
  }

  start (event) {
    triggerOn($grid, 'armMines');
  }

  gameOver (event) {
    node.querySelector('.message').setInnerHtml('Game Over');
    node.classes.add('over');
    triggerOnAll($mines, 'reveal');
    triggerOn($grid, 'disable');
  }

}