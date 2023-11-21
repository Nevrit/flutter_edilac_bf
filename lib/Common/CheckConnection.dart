import 'dart:async';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

bool hasInternet = false;

ConnectivityResult result = ConnectivityResult.none;

class CheckConnection {
  main() async {
    // Check internet connection with singleton (no custom values allowed)
    // await InternetConnectionChecker();
    result = await Connectivity().checkConnectivity();
    hasInternet = await InternetConnectionChecker().hasConnection;
    final text = hasInternet ? "Internet" : "No Internet";
    final color = hasInternet ? Colors.green : Colors.red;
    // showSimpleNotification(Text(text), background: color);
    if (result == ConnectivityResult.mobile) {
      showSimpleNotification(Text(text), background: color);
    } else if (result == ConnectivityResult.wifi) {
      showSimpleNotification(Text(text), background: color);
    } else {
      showSimpleNotification(Text(text), background: color);
    }
  }

  Future<void> execute(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    print('''The statement 'this machine is connected to the Internet' is: ''');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: avoid_print
            print('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
            // ignore: avoid_print
            print('You are disconnected from the internet.');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }
}
