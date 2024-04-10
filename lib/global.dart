import 'package:flutter/material.dart';

String apiUrl = "https://attendencebackend.azurewebsites.net";
bool statsUpdate = true;
bool statusUpdate = true;

class ObserverUtils {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}
