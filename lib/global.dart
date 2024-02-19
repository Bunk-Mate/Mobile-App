import 'package:flutter/material.dart';

String apiUrl = "https://attendencebackend.azurewebsites.net";
bool statsUpdate = false;
bool statusUpdate = false;

class ObserverUtils {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

