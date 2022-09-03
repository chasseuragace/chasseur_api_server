import 'package:dart_frog/dart_frog.dart';

import '../app/auth/authentication.dart';
import '../app/database/db.dart';

import '../app/database/models/user.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger());
}
