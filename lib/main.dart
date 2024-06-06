import 'dart:ui';

import 'package:farmer_geo_locator/src/app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(const MainApp());
}
