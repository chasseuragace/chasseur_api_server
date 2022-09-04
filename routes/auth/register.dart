import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';

import '../../app/auth/authentication.dart';
import '../../app/database/db.dart';

import '../../app/database/models/user.dart';
import '../../app/mail_sender/mail_sender.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'message': 'Use POST for registration'},
    );
  }
  try {
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    late final User requestedUser;
    try {
      requestedUser = User.fromMap(body);
      print(requestedUser.toMap());
      if (requestedUser.name == null) throw LogicEception();
    } on Exception {
      return Response.json(
        statusCode: HttpStatus.expectationFailed,
        body: {'message': 'payload is not valid'},
      );
    }

    if (!isValid(requestedUser.email)) {
      return Response.json(
        statusCode: HttpStatus.expectationFailed,
        body: {
          'message': '${requestedUser.email} is not a valid email address'
        },
      );
    }
    final code = Random().nextInt(67898) + 11111;

    final passwordHash = JWTTokenHandler.generateHash(
        email: requestedUser.email, password: body['password'].toString());
    final user = User(
      email: requestedUser.email,
      hashedPassword: passwordHash,
      name: requestedUser.name,
      code: code.toString(),
    );
    final res =
        await Collection<User>().save(user, check: {'email': user.email});

    await MailService().sendMail(
      'Veriying your phone number',
      'use <b>$code</b> to confirm your account!',
      'chasseuragace@gmail.com',
    );

    return Response.json(body: {
      'message': 'Registration Successfull',
      'data': User.fromMap(res).toSecureMap()
    });
  } on LogicEception {
    return Response.json(
      statusCode: HttpStatus.preconditionFailed,
      body: {'error': 'The email is already taken.'},
    );
  } on Exception catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}

bool isValid(String email) {
  final emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);
  return emailValid;
}
