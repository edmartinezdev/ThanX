import 'package:flutter/material.dart';

class NavigationService {
  static NavigationService _instance = NavigationService._internal();
  NavigationService._internal() {}

  factory NavigationService(){
    return _instance;
  }
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateNamedTo(String routeName,) {
    FocusScope.of(navigatorKey.currentContext).unfocus();
    return navigatorKey.currentState.pushNamed(routeName,);
  }

  Future<dynamic> push<T extends Object>(Route<T> route) {
    FocusScope.of(navigatorKey.currentContext).unfocus();
    return navigatorKey.currentState.push(route,);
  }

  Future<dynamic> pushReplacement<T extends Object>(Route<T> route) {
    FocusScope.of(navigatorKey.currentContext).unfocus();
    return navigatorKey.currentState.pushReplacement(route,);
  }

  Future<dynamic> pushAndRemoveUntil<T extends Object>(Route<T> route,RoutePredicate predicate) {
    FocusScope.of(navigatorKey.currentContext).unfocus();
    return navigatorKey.currentState.pushAndRemoveUntil(route,predicate);
  }
  Future<dynamic> navigateRemoveAndUntilNamed(String routeName) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (_)=>false);
  }

  void pop({int result}) {
    navigatorKey.currentState.pop( result ?? 0);
  }

  // bool pop({int result}) {
  //   return navigatorKey.currentState.pop( result ?? 0);
  // }

}