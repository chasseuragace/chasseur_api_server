import 'package:dart_frog/dart_frog.dart';

import '../../app/auth/authentication.dart';

///logger
Handler middleware(Handler handler) {
  try {
    return handler.use(UserFromTokenProvider());
  } on Exception catch (e) {
    return handler;
  }
}
