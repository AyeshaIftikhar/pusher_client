import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PusherClient pusher;
  late Channel channel;

  @override
  void initState() {
    super.initState();

    String token = getToken();

    pusher = PusherClient(
      "app-key",
      PusherOptions(
        // if local on android use 10.0.2.2
        host: 'localhost',
        encrypted: false,
        auth: PusherAuth(
          'http://example.com/broadcasting/auth',
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
      enableLogging: true,
    );

    channel = pusher.subscribe("private-orders");

    pusher.onConnectionStateChange((state) {
      log(
        "previousState: ${state?.previousState}, currentState: ${state?.currentState}",
      );
    });

    pusher.onConnectionError((error) {
      log("error: ${error?.message}");
    });

    channel.bind('status-update', (event) {
      log(event?.data.toString() ?? "No data");
    });

    channel.bind('order-filled', (event) {
      log("Order Filled Event${event?.data.toString() ?? "No data"}");
    });
  }

  String getToken() => "super-secret-token";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example Pusher App')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Text('Unsubscribe Private Orders'),
                onPressed: () {
                  pusher.unsubscribe('private-orders');
                },
              ),
              ElevatedButton(
                child: Text('Unbind Status Update'),
                onPressed: () {
                  channel.unbind('status-update');
                },
              ),
              ElevatedButton(
                child: Text('Unbind Order Filled'),
                onPressed: () {
                  channel.unbind('order-filled');
                },
              ),
              ElevatedButton(
                child: Text('Bind Status Update'),
                onPressed: () {
                  channel.bind('status-update', (event) {
                    log(
                      "Status Update Event${event?.data?.toString() ?? 'No data'}",
                    );
                  });
                },
              ),
              ElevatedButton(
                child: Text('Trigger Client Typing'),
                onPressed: () {
                  channel.trigger('client-istyping', {'name': 'Bob'});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PusherClient>('pusher', pusher));
  }
}
