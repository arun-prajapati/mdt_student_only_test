import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    // print(arguments);
    if (arguments != null) {
      return navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState!.pushNamed(routeName);
    }
  }

  Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
    //return navigatorKey.currentState.pushNamed(routeName);
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToRemoveUntil(String routeName, {Object? arguments}) {
    //return navigatorKey.currentState.pushNamed(routeName);
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> makeFirst(String routeName) {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
