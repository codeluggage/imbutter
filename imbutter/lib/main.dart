import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as router;
import 'package:shelf/shelf_io.dart' as io;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // Response _echoRequest(Request request) {
  //   return Response.ok(jsonEncode({
  //     'url': request.url.toString(),
  //     'method': request.method,
  //     'headers': request.headers.toString(),
  //   }));
  // }

  // final handler =
  //     const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  // final server = await io.serve(handler, 'localhost', 8080);

  // server.autoCompress = true;

  var app = router.Router();
  final player = AudioPlayer();

  const fileName = 'fortune.mp3';
  final content = await rootBundle.load("assets/audio/$fileName");
  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/$fileName");
  file.writeAsBytesSync(content.buffer.asUint8List());

  app.get('/hello', (Request request) {
    return Response.ok('hello-world');
    // return Response.ok(jsonEncode({
    //   'url': request.url.toString(),
    //   'method': request.method,
    //   'headers': request.headers.toString(),
    // }));
  });

  app.get('/user/<user>', (Request request, String user) {
    return Response.ok('hello $user');
  });

  const audioPath = 'just_audio';

  app.post('/$audioPath/play', (Request request) async {
    final stringBody = await request.readAsString();
    final body = jsonDecode(stringBody);
    if (kDebugMode) print(body);

    await player.setFilePath(file.path);
    await player.play();

    return Response.ok('done playing ${file.path}');
  });

  final server = await io.serve(app, 'localhost', 8080);
  server.autoCompress = true;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      allowUniversalAccessFromFileURLs: true,
      allowFileAccessFromFileURLs: true,
      disableContextMenu: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  double progress = 0;
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          // child: progress < 1.0
          //     ? LinearProgressIndicator(value: progress)
          child: InAppWebView(
            key: webViewKey,
            initialFile: 'assets/imbutter/html/index.html',
            initialOptions: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              debugPrint('onLoadStart: $url');
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onLoadStop: (controller, url) async {
              debugPrint('onLoadStop: $url');
            },
            onLoadError: (controller, url, code, message) {
              debugPrint("onLoadError, got $code with $message for $url");
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              debugPrint("onUpdateVisitedHistory url: $url");
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint(consoleMessage.toString());
            },
          ),
        ),
      ),
    );
  }
}
