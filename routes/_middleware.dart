import 'package:dart_frog/dart_frog.dart';

import '../app/auth/authentication.dart';
import '../app/database/db.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger());
}
