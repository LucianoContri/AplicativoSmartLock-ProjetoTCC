import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/utils/constants.dart';

class LabList with ChangeNotifier {
  final _url =
      'https://smartlocktcc-default-rtdb.firebaseio.com/Laborat%C3%B3rios.json';
  List<Laboratorio> _items = [];
  String _token;

  List<Laboratorio> get items => [..._items];

  LabList(this._token, this._items);

  int get itemsCount {
    return _items.length;
  }

  Future<void> IsAdmin(String UserId) async {
    final response = await http.get(
      Uri.parse('${Constants.Usuarios_URL}/$UserId.json?auth=$_token'),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    final bool isadmin = data['administrador'];
  }

  Future<void> AddLab(Laboratorio laboratorio) async {
    final response = await http.post(
      Uri.parse('${Constants.Laboratorios_URL}.json?auth=$_token'),
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

    final id = jsonDecode(response.body)['Nome'];
    _items.add(Laboratorio(
      id: id,
      Nome: laboratorio.Nome,
      Campus: laboratorio.Campus,
      Descricao: laboratorio.Descricao,
      UrlImagem: laboratorio.Descricao,
      chaveNFC: laboratorio.chaveNFC,
    ));

    notifyListeners();
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.Laboratorios_URL}.json?auth=$_token'),
    );
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
