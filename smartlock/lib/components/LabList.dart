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
    // Laboratorio(
    //   id: productId,
    //   Nome: productData['Nome'],
    //   Campus: productData['Campus'],
    //   Descricao: productData['Descricao'],
    //   UrlImagem: productData['UrlImagem'],
    //   chaveNFC: productData['chaveNFC'],
  }
}
