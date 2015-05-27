library tile;

import 'dart:async';
import 'component.dart';

class Tile extends ComponentHandler {

  Stream get onReveal => node.on['reveal'];

  initialize () {
    node.onClick.first.then((_) => trigger('reveal'));
    onReveal.listen(reveal);
  }

  reveal (event) => node.classes.add('revealed');

}