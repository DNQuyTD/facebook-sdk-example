import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:fexample/fb_observer.dart';

class AnalyticsService {
  final FacebookAppEvents _analytics = FacebookAppEvents();

  FbAnalyticsObserver getFbAnalyticsObserver() =>
      FbAnalyticsObserver(analytics: _analytics);

  Future logScreen({required String? name}) async {
    await _analytics.logViewContent(content: {'screenName': name});
  }
}