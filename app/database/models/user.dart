import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import '../../auth/authentication.dart';
import 'base/collections.dart';

class User extends Coll {
  ROLE? role;

  factory User.fromMap(Map<String, dynamic> json) => User(
        oid: json['_id'] != null ? json['_id'] as ObjectId : null,
        id: (json['_id'] ?? json['id'])?.toString(),
        email: json['email'] as String,
        role: json['role'].toString().assignRole(),
        isVerified: ((json['is_verified']) ?? false) as bool,
        hashedPassword: json['hashed_password']?.toString(),
        name: json['name']?.toString(),
        code: json['code']?.toString(),
      );
  User({
    required this.email,
    this.isVerified = false,
    this.role = ROLE.customer,
    this.hashedPassword,
    this.name,
    this.oid,
    this.code,
    this.id,
  });
  final ObjectId? oid;
  final String email;
  final String? hashedPassword;
  final String? id;
  final String? name;
  final String? code;
  final bool isVerified;

  String toJson() => json.encode(toMap());
  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'code': code,
        'role': role?.name,
        'name': name,
        'hashed_password': hashedPassword,
        'is_verified': isVerified
      }..removeWhere((key, value) => value == null);

  Map<String, dynamic> toSecureMap() =>
      {'email': email, 'name': name, 'is_verified': isVerified};
}
