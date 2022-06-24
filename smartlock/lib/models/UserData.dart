import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  final String id;
  final String campus;
  final String? agendamento;
  final bool isAdmin;

  UserData({
    required this.id,
    required this.isAdmin,
    required this.campus,
    this.agendamento,
  });
}
