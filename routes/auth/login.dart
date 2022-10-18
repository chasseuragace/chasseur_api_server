import 'dart:convert';
import 'package:app_models/app_models.dart';
import 'package:dart_frog/dart_frog.dart';
import '../../app/auth/authentication.dart';
import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      throw AppExceptions(message: 'Use POST for login');
    }
    final body = jsonDecode(await context.request.body()) as Map;
    final email = body['email'] as String;
    final password = body['password'].toString();

    await Collection<User>().findBy({
      'email': email,
      'hashed_password':
          JWTTokenHandler.generateHash(email: email, password: password)
    });

    return successResponse(
      json: {'token': JWTTokenHandler.generatetokenForUser(email)},
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}
