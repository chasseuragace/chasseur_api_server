import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_models/models/user.dart';
import 'package:dart_frog/dart_frog.dart';
import '../../app/auth/authentication.dart';
import '../../app/database/db.dart';

import '../../app/error/errors.dart';
import '../../app/mail_sender/mail_sender.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    throw AppExceptions(
      message: 'Use POST for registration',
    );
  }
  try {
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    late final User requestedUser;
    requestedUser = User.fromMap(body);
    if ([requestedUser.email, requestedUser.name, body['password'].toString()]
        .contains(null)) throw AppExceptions(message: 'Payload is not valid');

    if (!isValid(requestedUser.email!)) {
      throw AppExceptions(
        message: '${requestedUser.email} is not a valid email address',
      );
    }
    final code = Random().nextInt(67898) + 11111;
    final passwordHash = JWTTokenHandler.generateHash(
      email: requestedUser.email!,
      password: body['password'].toString(),
    );
    final user = User(
      email: requestedUser.email?.toLowerCase(),
      hashedPassword: passwordHash,
      name: requestedUser.name,
      code: code.toString(),
    );
    final res =
        await Collection<User>().save(user, check: {'email': user.email});

    await MailService().sendMail(
      'Veriying your account<br>',
      'use <b>$code</b> to confirm your account!',
      user.email!,
    );
    return successResponse(json: User.fromMap(res).toSecureMap());
  } on Exception catch (e) {
    return handelError(e);
  }
}

bool isValid(String email) {
  final emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);
  return emailValid;
}
