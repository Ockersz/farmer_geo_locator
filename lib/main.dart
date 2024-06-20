import 'dart:ui';

import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_repository.dart';
import 'package:farmer_geo_locator/src/app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FarmerDetailsAdapter());
  // Hive.registerAdapter(UserDetailsAdapter());
  FarmerRepository farmerRepository = FarmerRepository();
  // UserRepository userRepository = UserRepository();
  await farmerRepository.init();
  runApp(const MainApp());
}
