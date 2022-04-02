import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:http/http.dart' as http;

import 'dart:io';

// import 'package:dart_shelf_server_sample/files/controller.dart';
// import 'package:dart_shelf_server_sample/helpers/helpers.dart';
// import 'package:dart_shelf_server_sample/posts/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_static/shelf_static.dart';

shelf_router.Router routes() {
  var app = shelf_router.Router();

  app.get('/', (Request request) {
    // var html = File('public/index.html').readAsStringSync();
    return Response.ok("<h1>good</h1>", headers: {'Content-Type': 'text/html'});
  });

  app.get('/hello-html', (Request request) {
    return Response.ok("<h1>good html</h1>",
        headers: {'Content-Type': 'text/html'});
  });

  app.get('/hello-text', (Request request) {
    return Response.ok("good", headers: {'Content-Type': 'text/plain'});
  });

  // app.get('/assets/<file>', createStaticHandler('public'));

  // app.get('/api', (Request request) {
  //   var response = {
  //     'message': 'Dart API is alive',
  //     'api_routes': ['/posts', '/posts/{id}']
  //   };
  //   return Response.ok(toJson(response));
  // });

  // app.get('/posts', (Request request) {
  //   return PostController().find();
  // });

  // app.get('/posts/<id>', (Request request, String id) {
  //   return PostController().findOne(id);
  // });

  // app.get('/files', (Request request) {
  //   return FileController().find();
  // });

  // app.get('/<file>', FileController().findOne());

  return app;
}

Response _echoRequest(Request request) {
  // io.handleRequest(request, (request) {
  //   debugPrint(request);
  //   return new Response.ok(json.encode({
  //     'method': request.method,
  //     'uri': request.requestedUri.toString(),
  //     'headers': request.headers.toString(),
  //     'body': request.read().toString(),
  //   }));
  // });
  // final fixed = request.change(headers: {
  //   // 'method': 'GET',
  //   // 'destination: "object",
  //   // 'headers': {
  //   'Content-Type': 'application/json',
  //   // 'Content-Type': 'text/html',
  //   // },
  // });
  // final attempt = Request(
  //   request.method,
  //   request.requestedUri,
  //   headers: fixed.headers,
  //   context: fixed.context,
  //   body: request.read(),
  //   encoding: fixed.encoding,
  //   handlerPath: fixed.handlerPath,
  //   // handler: fixed.handler,
  //   // match: fixed.match,
  //   protocolVersion: fixed.protocolVersion,
  //   url: fixed.url,
  //   // query: fixed.query,
  // );
  // request.hijack((p0) {
  //   debugPrint('hijack');
  //   debugPrint(p0.toString());
  // });

  return Response.ok('Request for "${request.url}"',
      headers: {'Content-Type': 'text/plain'});
  // return Response.ok();
  // var response = {
  //   'message': 'Dart API is alive',
  //   'api_routes': ['/posts', '/posts/{id}']
  // };
  // return Response.ok(toJson(response));
}

Middleware handleCors() {
  var corsHeaders = {
    'Access-Control-Allow-Origins': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  return createMiddleware(requestHandler: (Request request) {
    if (request.method.toLowerCase() == 'options') {
      return Response.ok('', headers: corsHeaders);
    }
    return null;
  }, responseHandler: (Response response) {
    return response.change(headers: corsHeaders);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  var app = routes();

  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  var server = await io.serve(handler, 'localhost', 8080);
  server.handleError((error, stackTrace) {
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
  });

  // Enable content compression
  // server.autoCompress = true;

  debugPrint('Serving at http://${server.address.host}:${server.port}');

  // var app = shelf_router.Router();

  // // app.get('/api/v1/hello', (Request request) {
  // app.get('/hello', (Request request) {
  //   return Response.ok(
  //     'hello-world-from-flutter',
  //     headers: {'content-type': 'text/plain'},
  //     encoding: Encoding.getByName('utf-8'),
  //     context: request.context,
  //   );
  //   // return Response.ok('hello world');
  //   // request.change(headers: {
  //   //   'Content-Type': 'application/json',
  //   // });

  //   // return Response.ok({'payload': 'hello-world'});
  // });

  // app.get('/user/<user>', (Request request, String user) {
  //   // app.get('/api/v1/user/<user>', (Request request, String user) {
  //   return Response.ok('hello $user');
  // });

  // var _port = 8080;
  // var server = await io.serve(app, 'localhost', _port);
  // debugPrint(server.toString());

  // final res = await http.get(Uri.http('localhost:$_port', '/'));
  // debugPrint(res.toString());
  // debugPrint(res.body);

  // final hello = await http.get(Uri.http('localhost:$_port', '/hello'));
  // debugPrint(hello.toString());
  // debugPrint(hello.body);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'WebView';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WebViewPlusController controller;

  // void loadLocalHtml() async {
  //   final html = await rootBundle.loadString('assets/index.html');

  //   final url = Uri.dataFromString(
  //     html,
  //     mimeType: 'text/html',
  //     encoding: Encoding.getByName('utf-8'),
  //   ).toString();

  //   controller.loadUrl(url);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (error) {
            debugPrint(error.toString());
          },
          // serverPort: _port,
          initialUrl: 'assets/index.html',
          navigationDelegate: (NavigationRequest request) {
            debugPrint(request.toString());
            return NavigationDecision.navigate;
          },
          onWebViewCreated: (controller) {
            this.controller = controller;
            // loadLocalHtml();
          },
          onPageFinished: (url) {
            debugPrint('onPageFinished: $url');
            controller.webViewController.runJavascript("""
    fetch(new Request(
        'http://localhost:8080/hello-html'
    )).then(function (response) {
        h1.textContent = JSON.stringify(response)
        response.text().then((text) => {
            coloredDiv.setAttribute('style', 'background:green;')
            h2.textContent = text
        }).catch(error => {
            coloredDiv.setAttribute('style', 'background:purple;')
            h3.textContent = error
        });
      }).catch(function(error) {
        coloredDiv.setAttribute('style', 'background:red;')
        h4.textContent = error
    })
""");
          },
          javascriptChannels: {
            JavascriptChannel(
              name: 'JavascriptChannel',
              onMessageReceived: (message) async {
                debugPrint('Javascript: "${message.message}"');

                // controller.webViewController.runJavascript('ok()');

                // controller.webViewController
                //     .runJavascriptReturningResult('ok()')
                //     .then((value) {
                //   debugPrint('Javascript: "$value"');
                // });
              },
            ),
          },
        ),
      );
}
