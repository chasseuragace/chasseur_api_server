import 'package:dart_frog/dart_frog.dart';

import '../../app/auth/authentication.dart';

///logger
Handler middleware(Handler handler) {
  try {
    return handler.use(asyncGreetingProvider());
  } on Exception catch (e) {
    return handler;
  }
}
