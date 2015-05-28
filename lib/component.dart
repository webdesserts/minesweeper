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
      handler.trigger('initialized');
    }
  }
}

abstract class ComponentHandler {
  Element node;

  ElementEvents get on => node.on;
  ElementStream get onInitialized => node.on['initialized'];

  Function get querySelector => node.querySelector;
  Function get querySelectorAll => node.querySelectorAll;

  void initialize ();

  _attachTo (element) {
    node = element;
    initialize();
  }

  trigger (String name) => node.dispatchEvent(new CustomEvent(name, detail: this));
  triggerOn (String selector, String name, [Object details]) => querySelector(selector).dispatchEvent(new CustomEvent(name, detail: details ? details : this));
  triggerOnAll (String selector, String name) {
    var elements = querySelectorAll(selector);
    for (var element in elements) {
      element.dispatchEvent(new CustomEvent(name, detail: this));
    }
  }

  dispatch (CustomEvent event) => node.dispatchEvent(event);
  dispatchOn (String selector, CustomEvent event) => querySelector(selector).dispatchEvent(event);
  dispatchOnAll (String selector, CustomEvent event) {
    var elements = querySelectorAll(selector);
    for (var element in elements) {
      element.dispatchEvent(event);
    }
  }
}