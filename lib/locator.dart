import 'package:fexample/services/analytics_service.dart';
import 'package:fexample/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => NavigationService(locator()));
}