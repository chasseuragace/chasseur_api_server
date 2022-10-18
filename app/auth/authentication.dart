// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_models/models/base/collections.dart';
import 'package:app_models/models/user.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../database/db.dart';
import '../error/errors.dart';

extension e on String {
  ROLE assignRole() {
    return ROLE.values.singleWhere(
      (element) => element.name.toLowerCase() == toLowerCase(),
      orElse: () => ROLE.customer,
    );
  }
}

class JWTTokenHandler {
  static final String _ISSUER =
      Platform.environment['ISSUER'] ?? 'chasseuragace';
  static final _SECRET_KEY =
      Platform.environment['SECRET_KEY'] ?? '34klj23*&#jdhlj2s';

  static String generatetokenForUser(String email) {
    // Create a claim set
    final claimSet = JwtClaim(
      issuer: _ISSUER,
      audience: ['app.chasseuragace.com'],
      subject: email,
      jwtId: _randomString(32),
      maxAge: const Duration(days: 5),
    );

    // Generate a JWT from the claim set
    return issueJwtHS256(claimSet, _SECRET_KEY);
  }

  static dynamic validateToken(String token) {
    try {
      final decClaimSet = verifyJwtHS256Signature(token, _SECRET_KEY)
        ..validate(
          issuer: _ISSUER,
          audience: 'app.chasseuragace.com',
        );
      return decClaimSet.subject;
    } on JwtException catch (e) {
      log('Error: bad JWT: $e ${e.message == JwtException.tokenExpired.message}');
      return e;
    } catch (e) {
      return e;
    }
  }

  static String _randomString(int length) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rnd = math.Random(DateTime.now().millisecondsSinceEpoch);
    final buf = StringBuffer();

    for (var x = 0; x < length; x++) {
      buf.write(chars[rnd.nextInt(chars.length)]);
    }
    return buf.toString();
  }

  static String generateHash({
    required String email,
    required String password,
  }) {
    final saltBytes = '$email$_SECRET_KEY'.codeUnits;
    final salt = base64.encode(saltBytes);
    final key = utf8.encode(password);
    final bytes = utf8.encode(salt);
    return Hmac(sha256, key).convert(bytes).toString();
  }
}

Middleware UserFromTokenProvider({ROLE? role}) {
  return provider<Future<User>>((context) async {
    final authTokenKey = context.request.headers.keys.singleWhere(
      (element) => element.toLowerCase() == 'authorization',
      orElse: () =>
          throw AppExceptions(message: 'Missing authorization header'),
    );

    final token = context.request.headers[authTokenKey] ?? '';
    final email = await JWTTokenHandler.validateToken(token);
    if (email is! Exception) {
      final userData = await Collection<User>().findBy({'email': email});

      // handler.use(provider<User>((context) => User.fromMap(userData)));
      final user = User.fromMap(userData);
      if (role != null && user.role != role) {
        throw AppExceptions(message: 'Action not permitted for : ${user.role}');
      }
      return user;
    }
    throw AppExceptions(message: "Something isn't right");
  });
}
