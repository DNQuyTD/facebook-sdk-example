import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:fexample/locator.dart';
import 'package:fexample/services/navigation_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: locator<NavigationService>().getRouter(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}
