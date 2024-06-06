import 'package:farmer_geo_locator/src/locator_home.dart/view.dart';
import 'package:farmer_geo_locator/src/setti/view.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case SettingsView.routeName:
            builder = (BuildContext _) => const SettingsView();
            break;
          case LocatorHome.routeName:
          default:
            builder = (BuildContext _) => const LocatorHome();
            break;
        }
        return MaterialPageRoute<void>(
          builder: builder,
          settings: routeSettings,
        );
      },
    );
  }
}
