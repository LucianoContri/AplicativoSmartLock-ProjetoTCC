import 'package:flutter/cupertino.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/models/User.dart';

class Reserve with ChangeNotifier {
  final String id;
  final Laboratorio laboratorio;
  final User usuario;
  final DateTime horario;
  final Duration duracao;
  String status;
  final List<User> integrantes;

  Reserve({
    required this.id,
    required this.laboratorio,
    required this.usuario,
    required this.horario,
    required this.status,
    required this.duracao,
    required this.integrantes,
  });
}
