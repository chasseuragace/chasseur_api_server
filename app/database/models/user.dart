import 'dart:convert';

import '../../auth/authentication.dart';
import 'base/collections.dart';

class User extends Coll {
  String? role;

  factory User.fromMap(Map<String, dynamic> json) => User(
        email: json['email'] as String,
        role: ((json['role']) ?? ROLE.customer.name).toString(),
        isVerified: ((json['is_verified']) ?? false) as bool,
        hashedPassword: json['hashed_password'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
      );
  User({
    required this.email,
    required this.isVerified,
    required this.role,
    required this.hashedPassword,
    required this.name,
    required this.code,
  });

  final String email;
  final String hashedPassword;
  final String name;
  final String code;
  final bool isVerified;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'email': email,
        'code': code,
        'name': name,
        'hashed_password': hashedPassword,
        'is_verified': isVerified
      }..removeWhere((key, value) => value == null);
  Map<String, dynamic> toSecureMap() =>
      {'email': email, 'name': name, 'is_verified': isVerified};
}
