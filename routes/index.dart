import 'package:dart_frog/dart_frog.dart';

import '../app/locator.dart';

Response onRequest(RequestContext context) {
  return Response(body: 'Welcome to Dart Frog!');
}
