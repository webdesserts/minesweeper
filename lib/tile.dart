library tile;

import 'component.dart';
import 'dart:html';
import 'dart:async';

class Tile extends ComponentHandler {

  bool isMine = false;
  bool isRevealed = false;
  bool isEnabled = false;
  num nearbyMines = 0;
  bool get isEmpty => (!isMine && nearbyMines == 0);
  StreamSubscription selectable;


  ElementStream get onReveal => node.on['reveal'];
  ElementStream get onReset => node.on['reset'];
  ElementStream get onArmMine => node.on['armMine'];
  ElementStream get onSelect => node.on['select'];
  ElementStream get onNearMine => node.on['nearMine'];
  ElementStream get onCascadeReveal => node.on['cascadeReveal'];
  ElementStream get onDisable => node.on['disable'];
  ElementStream get onEnable => node.on['enable'];

  initialize () {
    var result = new DivElement();
    result.classes.add('result');
    node.append(result);
    onReset.listen(reset);
    onArmMine.listen(armMine);
    onNearMine.listen(nearMine);
    onDisable.listen(disable);
    onEnable.listen(enable);
    window.onResize.listen((_) => resizeText());
    resizeText();
    setupEvents();
  }

  /// setup single fire events;
  setupEvents () {
    print('setting up events');
    node.onClick.first.then((_) => trigger('select'));
    onReveal.first.then(reveal);
    onCascadeReveal.first.then(reveal);

  }

  resizeText () {
    var width = node.getComputedStyle().width;
    var digitsExp = new RegExp(r'\d+\.?\d+');
    double raw = double.parse(digitsExp.firstMatch(width)[0]);
    var font_size = width.replaceFirst(digitsExp, (raw*.4).toString());
    node.style.fontSize = font_size;
  }

  select (event) {
    print('selected');
    if (isEnabled) reveal(event);
  }

  reveal (CustomEvent event) {
    if (!isRevealed) {
      node.classes.add('revealed');
      isRevealed = true;
      if (isMine) {
        trigger('trippedMine');
      }
    }
    trigger('revealed');
  }

  reset (event) {
    setupEvents();

    node.classes.remove('revealed');
    node.classes.remove('mine');
    var result = node.querySelector('.result');
    result.innerHtml ='';

    isMine = false;
    isRevealed = false;
    isEnabled = false;
    nearbyMines = 0;
  }

  armMine(event) {
    isMine = true;
    node.classes.add('mine');
    print('setMine');
  }

  nearMine(event) {
    nearbyMines++;
    node.querySelector('.result').innerHtml = nearbyMines.toString();
  }

  enable(event) {
    print('tile enabled');
    isEnabled = true;
    selectable = onSelect.listen(select);
  }

  disable(event) {
    print('tile disabled');
    isEnabled = false;
    selectable.cancel();
  }


}