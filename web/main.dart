// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:minesweeper/game.dart';
import 'package:minesweeper/component.dart';
import 'dart:html';

void main() {
  var game = new Component(() => new Game());
  game.attachTo('#game');
}
