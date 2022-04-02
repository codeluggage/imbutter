import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;

// Response _echoRequest(Request request) =>
//     Response.ok('Request for "${request.url}"');

import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:http/http.dart' as http;

void main() async {
  // var handler =
  //     const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  // var server = await shelf_io.serve(handler, 'localhost', 8080);

  // // Enable content compression
  // server.autoCompress = true;

  // debugPrint('Serving at http://${server.address.host}:${server.port}');

  var app = shelf_router.Router();

  app.get('/hello', (Request request) {
    return Response.ok('hello-world');
  });

  app.get('/user/<user>', (Request request, String user) {
    return Response.ok('hello $user');
  });

  var _port = 8080;
  var server = await io.serve(app, 'localhost', _port);
  debugPrint(server.toString());

  final res = await http.get(Uri.http('localhost:$_port', '/'));
  debugPrint(res.toString());
  debugPrint(res.body);

  final hello = await http.get(Uri.http('localhost:$_port', '/hello'));
  debugPrint(hello.toString());
  debugPrint(hello.body);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  // runApp(MyApp(settingsController: settingsController));
  runApp(const MyApp());
}
