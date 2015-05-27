library Component;

import 'dart:html';

class Component {

  Function _create;

  Component (this._create);

  attachTo (String selector) {
    ElementList elements = querySelectorAll(selector);
    for (var element in elements) {
      ComponentHandler handler = _create();
      handler._attachTo(element);
      handler.trigger('initialize');
    }
  }
}

abstract class ComponentHandler {
  Element node;
  //Stream get onClick => node.onClick;
  //Stream get onMouseLeave => node.onMouseLeave;
  //Stream get onMouseMove => node.onMouseMove;
  //Stream get onMouseDown => node.onMouseDown;
  //Stream get onMouseUp => node.onMouseUp;
  //Stream get onMouseOver => node.onMouseOver;
  //Stream get onMouseEnter => node.onMouseEnter;
  //Stream get onMouseWheel => node.onMouseWheel;
  //Stream get onFocus => node.onFocus;
  //Stream get onBlur => node.onBlur;

  Function get querySelector => node.querySelector;
  Function get querySelectorAll => node.querySelectorAll;

  void initialize ();

  _attachTo (element) {
    node = element;
    initialize();
  }

  trigger (String name) => node.dispatchEvent(new CustomEvent(name, detail: this));

  dispatch (CustomEvent event) => node.dispatchEvent(event);
  
}