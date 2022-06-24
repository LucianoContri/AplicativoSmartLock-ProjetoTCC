import 'package:flutter/cupertino.dart';

class Laboratorio with ChangeNotifier {
  final String id;
  final String nome;
  final String campus;
  final String descricao;
  final String urlImagem;
  final String chaveNFC;

  Laboratorio({
    required this.id,
    required this.nome,
    required this.campus,
    required this.descricao,
    required this.urlImagem,
    required this.chaveNFC,
  });
}
