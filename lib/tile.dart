import 'dart:html';

class Tile {
  ButtonElement node;
  List subscriptions;
  num row;
  num col;

  Tile (this.row, this.col) {
    this.node = new ButtonElement();
    this.node.className = "tile";
  }

  on (String name, Function func) {
    this.node.on[name].listen(func);
  }

  trigger (String name) {
    this.node.dispatchEvent(new CustomEvent(name));
  }

}