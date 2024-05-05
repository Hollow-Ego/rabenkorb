import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension FinderExtension on CommonFinders {
  Finder byKeyOffstage(Key key) {
    return byKey(key, skipOffstage: false);
  }

  Finder getScrollableDescendant(Finder parent) {
    return find.descendant(
      of: parent,
      matching: find.byType(Scrollable).at(0),
    );
  }
}
