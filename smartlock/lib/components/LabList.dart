import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/models/Campus.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/utils/Constants.dart';

class LabList with ChangeNotifier {
  List<Laboratorio> _items = [];
  String _token;
  bool _isLoading = false;

  List<Laboratorio> get items => [..._items];
  bool get isLoading => _isLoading;

  LabList(this._token, this._items);

  int get itemsCount {
    return _items.length;
  }

  Future<void> addLab(Laboratorio laboratorio) async {
    final response = await http.post(
      Uri.parse('${Constants.laboratoriosURL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "Nome": laboratorio.nome,
          "Descricao": laboratorio.descricao,
          "Campus": laboratorio.campus,
          "UrlImagem": laboratorio.urlImagem,
          "chaveNFC": laboratorio.chaveNFC,
        },
      ),
    );

    final data = jsonDecode(response.body);
    if (data['error'] != null) {
      throw Exception(data['error']['message']);
    } else {
      _items.add(Laboratorio(
        id: laboratorio.id,
        nome: laboratorio.nome,
        campus: laboratorio.campus,
        descricao: laboratorio.descricao,
        urlImagem: laboratorio.urlImagem,
        chaveNFC: laboratorio.chaveNFC,
      ));
    }

    notifyListeners();
  }

  Future<void> loadProducts(BuildContext context, {String? campus}) async {
    _items.clear();
    _isLoading = true;
    Auth auth = Provider.of(context, listen: false);
    if (auth.isAdmin == null) {
      await auth.setUserData(auth.uid);
    }
    String query = '${Constants.laboratoriosURL}.json?auth=$_token';
    if (!auth.isAdmin!) {
      campus = auth.campus;
    }
    if (campus != null &&
        campus.isNotEmpty &&
        campus != Constants.allLabsAdmin) {
      query +=
          '&orderBy="Campus"&startAt="' + campus + '"&endAt="' + campus + '"';
    }
    final response = await http.get(
      Uri.parse(query),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((labid, labdata) {
      _items.add(
        Laboratorio(
          id: labid,
          nome: labdata['Nome'],
          campus: Campus.values.firstWhere((e) =>
              e.toString().toUpperCase() ==
              labdata['Campus'].toString().toUpperCase()),
          descricao: labdata['Descricao'],
          urlImagem: labdata['UrlImagem'],
          chaveNFC: labdata['chaveNFC'],
        ),
      );
    });
    notifyListeners();
  }

  void updateLoading(bool bool) {
    _isLoading = bool;
    notifyListeners();
  }
}
