import 'package:flutter/material.dart';

class Navigation {
  static navigate(BuildContext context, Widget screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static replace(BuildContext context, Widget screen) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static popAndPush(BuildContext context, Widget screen) {
    goBack(context);
    return navigate(context, screen);
  }

  static reset(BuildContext context, Widget screen) {
    return Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => screen), (route) => false);
  }

  static goBack(BuildContext context) {
    return Navigator.pop(context);
  }

  static openDrawer(BuildContext context) {
    return Scaffold.of(context).openDrawer();
  }

  static closeDrawer(BuildContext context) {
    return goBack(context);
  }
}
