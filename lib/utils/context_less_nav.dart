import 'package:flutter/material.dart';

//allows navigation with context.nav
extension ElTanvirNavigator on BuildContext {
  NavigatorState get nav {
    return Navigator.of(this);
  }
}

//converts
extension MiliSeconds on num {
  Duration get milisec {
    return Duration(milliseconds: int.parse(toString()));
  }
}
