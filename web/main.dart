// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:minesweeper/component.dart';
import 'package:minesweeper/game.dart';
import 'package:minesweeper/grid.dart';

void main() {
  var game = new Component(() => new Game(mines: 12));
  var grid = new Component(() => new Grid(rows: 10, cols: 10));
  grid.attachTo('#grid');
  game.attachTo('#game');
}
