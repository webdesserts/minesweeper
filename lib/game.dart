library Game;

import 'package:minesweeper/component.dart';
import 'dart:html';

class Game extends ComponentHandler {

  String $restart;
  String $grid;
  String $mines;
  num score;
  num mines;

  ElementStream get onStart => node.on['start'];
  ElementStream get onTrippedMine => node.on['trippedMine'];

  Game({
    this.mines: 1,
    this.$restart: '.restart',
    this.$grid: '#grid',
    this.$mines: '.tile.mine'
  });

  initialize () {
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