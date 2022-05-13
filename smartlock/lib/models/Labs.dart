import 'package:flutter/cupertino.dart';

class Laboratorio with ChangeNotifier {
  final String id;
  final String Nome;
  final String Campus;
  final String Descricao;
  final String UrlImagem;
  final String chaveNFC;

  Laboratorio({
    required this.id,
    required this.Nome,
    required this.Campus,
    required this.Descricao,
    required this.UrlImagem,
    required this.chaveNFC,
  });
}
