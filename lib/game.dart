library Game;

import 'package:minesweeper/component.dart';
import 'dart:html';

class Game extends ComponentHandler {

  String $restart;
  String $grid;
  num score;
  num mines;

  ElementStream get onStart => node.on['start'];
  ElementStream get onTrippedMine => node.on['game over'];

  Game({
    this.mines: 1,
    this.$restart: '#restart',
    this.$grid: '#grid'
  });

  initialize () {
    querySelector($restart).onClick.listen(restart);
    onStart.listen(start);
    onTrippedMine.listen(gameOver);
    trigger('start');
  }

  restart (event) {
    triggerOn($grid, 'reset');
    trigger('start');
  }

  start (event) {
    triggerOn($grid, 'armMines');
  }

  gameOver (event) {}

}