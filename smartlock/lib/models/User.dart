import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  final String id;
  final String token;
  final String? nome;
  final String campus;
  final String email;

  User({
    required this.id,
    required this.token,
    this.nome,
    required this.campus,
    required this.email,
  });
}
