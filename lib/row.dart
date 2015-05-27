import 'dart:html';

class Row {
  Element node;
  num index;

  Row (this.index) {
    this.node = new Element.div();
    this.node.className = "row";
  }
}