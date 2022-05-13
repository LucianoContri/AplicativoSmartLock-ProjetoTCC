import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:smartlock/models/Labs.dart';

class LabList with ChangeNotifier {
  final _url =
      'https://smartlocktcc-default-rtdb.firebaseio.com/Laborat%C3%B3rios.json';
  List<Laboratorio> _items = [];

  List<Laboratorio> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> AddLab(Laboratorio laboratorio) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          "Nome": laboratorio.Nome,
          "Descricao": laboratorio.Descricao,
          "Campus": laboratorio.Campus,
          "UrlImagem": laboratorio.UrlImagem,
          "chaveNFC": laboratorio.chaveNFC,
        },
      ),
    );
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse(_url));
    print(jsonDecode(response.body));
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((labid, labdata) {
      _items.add(
        Laboratorio(
          id: labid,
          Nome: labdata['Nome'],
          Campus: labdata['Campus'],
          Descricao: labdata['Descricao'],
          UrlImagem: labdata['UrlImagem'],
          chaveNFC: labdata['chaveNFC'],
        ),
      );
    });
    notifyListeners();
  }
}
