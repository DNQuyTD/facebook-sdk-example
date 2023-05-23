import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String _authStatus = 'Unknown';
  static final facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();

    // It is safer to call native code using addPostFrameCallback after the widget has been fully built and initialized.
    // Directly calling native code from initState may result in errors due to the widget tree not being fully built at that point.
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => initPlugin());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: facebookAppEvents.getAnonymousId(),
                builder: (context, snapshot) {
                  final id = snapshot.data ?? '???';
                  return Text('Anonymous ID: $id');
                },
              ),
              MaterialButton(
                child: Text("Click me!"),
                onPressed: () {
                  facebookAppEvents.logEvent(
                    name: 'button_clicked',
                    parameters: {
                      'button_id': 'the_clickme_button',
                    },
                  );
                },
              ),
              MaterialButton(
                child: Text("Set user data"),
                onPressed: () {
                  facebookAppEvents.setUserData(
                    email: 'opensource@oddbit.id',
                    firstName: 'Oddbit',
                    dateOfBirth: '2019-10-19',
                    city: 'Denpasar',
                    country: 'Indonesia',
                  );
                },
              ),
              MaterialButton(
                child: Text("Test logAddToCart"),
                onPressed: () {
                  facebookAppEvents.logAddToCart(
                    id: '1',
                    type: 'product',
                    price: 99.0,
                    currency: 'TRY',
                  );
                },
              ),
              MaterialButton(
                child: Text("Test purchase!"),
                onPressed: () {
                  facebookAppEvents.logPurchase(amount: 1, currency: "USD");
                },
              ),
              MaterialButton(
                child: Text("Enable advertise tracking!"),
                onPressed: () {
                  facebookAppEvents.setAdvertiserTracking(enabled: true);
                },
              ),
              MaterialButton(
                child: Text("Disabled advertise tracking!"),
                onPressed: () {
                  facebookAppEvents.setAdvertiserTracking(enabled: false);
                },
              ),
              MaterialButton(
                child: Text("Next screen"),
                onPressed: () {
                  context.go('/first-page');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
