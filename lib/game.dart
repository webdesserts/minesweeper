library Game;

import 'dart:html';

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
  ElementStream get onAllTilesRevealed => node.on['complete'];
  ElementStream get onSelect => node.on['select'];

  Game({
    this.mines: 100,
    this.size: 30,
    this.$restart: '.restart',
    this.$grid: '#grid',
    this.$mines: '.tile.mine'
  });

  initialize () {
    assert(mines < size*size);
    var grid = new Component(() => new Grid(rows: size, cols: size));
    grid.attachTo($grid);

    querySelectorAll($restart).onClick.listen(restart);

    newGame();
  }

  /// get everything up and running that's needed for each new game;
  newGame () {
    onSelect.first.then(start);
    onTrippedMine.first.then(gameOver);
    onAllTilesRevealed.first.then(greatSuccess);
  }

  /// arm the Mines and start the game!
  start (event) {
    print('starting');
    dispatchOn($grid, new CustomEvent('armMines', detail: { 'startTile': event.target, 'mines': mines }));
    triggerOn($grid, 'enable');
    event.target.dispatchEvent(new CustomEvent('reveal'));
  }

  /// clear the board, and get ready to start again
  restart (event) {
    triggerOn($grid, 'reset');

    node.classes.remove('over');
    node.classes.remove('win');

    newGame();
  }

  // Did you Win or Lose?

  /// I won everything!
  greatSuccess (event) {
    node.querySelector('.message').setInnerHtml('You Win!');
    node.classes.add('win');

    triggerOn($grid, 'disable');
  }

  /// I am a messy caracass
  gameOver (event) {
    node.querySelector('.message').setInnerHtml('Game Over');
    node.classes.add('over');

    triggerOnAll($mines, 'reveal');
    triggerOn($grid, 'disable');
  }

}