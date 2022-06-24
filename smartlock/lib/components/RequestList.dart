import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/models/Reserve.dart';
import 'package:smartlock/models/User.dart';
import 'package:smartlock/utils/Constants.dart';

class RequestList with ChangeNotifier {
  List<Reserve> _items = [];
  String _token;
  bool _isLoading = false;

  List<Reserve> get items => [..._items];
  bool get isLoading => _isLoading;
  RequestList(this._token, this._items);

  int get itemsCount {
    return _items.length;
  }

  Future<void> reserveLab(Laboratorio lab, Duration duracao, DateTime horario,
      List<User> integrantes, User user) async {
    bool isReserved = await checkReserve(lab.id, horario, duracao);

    if (isReserved) {
      return;
    }

    final response = await http.post(
      Uri.parse('${Constants.reservas_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "Laboratorio": lab.id,
          "Usuario": user.id,
          "Horario": horario.toString(),
          "Status": Constants.PENDING,
          "Duracao": duracao.inSeconds,
          "Integrantes": integrantes,
        },
      ),
    );

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['error'] != null) {
      throw Exception(data['error']['message']);
    } else {
      _items.add(Reserve(
        id: data['name'],
        laboratorio: lab,
        usuario: user,
        horario: horario,
        status: Constants.PENDING,
        duracao: duracao,
        integrantes: [],
      ));
    }
    notifyListeners();
  }

  Future<bool> checkReserve(
      String laboratorio, DateTime horario, Duration duracao) async {
    bool isReserved = false;
    final response = await http.get(
      Uri.parse(
          '${Constants.reservas_URL}.json?auth=$_token&orderBy="Status"&startAt="' +
              Constants.ACCEPTED +
              '"&endAt="' +
              Constants.ACCEPTED +
              '"'),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['error'] != null) {
      throw Exception(data['error']['message']);
    } else {
      data.removeWhere((key, value) => value['Laboratorio'] != laboratorio);
      data.forEach((labid, labdata) {
        DateTime temp = DateTime.parse(labdata['Horario']);
        if (horario.isAfter(temp) && horario.isBefore(temp.add(duracao))) {
          isReserved = true;
        }
      });
    }
    return isReserved;
  }

  Future<void> loadReserves(BuildContext context, String type) async {
    _items.clear();
    _isLoading = true;
    Auth auth = Provider.of(context, listen: false);
    if (auth.isAdmin == null) {
      await auth.setUserData(auth.uid);
    }
    String query =
        '${Constants.reservas_URL}.json?auth=$_token&orderBy="Status"&startAt="' +
            (type == Constants.RESERVE
                ? Constants.PENDING
                : Constants.ACCEPTED) +
            '"&endAt="' +
            (type == Constants.RESERVE
                ? Constants.PENDING
                : Constants.ACCEPTED) +
            '"';
    if (!auth.isAdmin! && type == Constants.RESERVE) {
      return;
    }
    final response = await http.get(
      Uri.parse(query),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (type == Constants.APPROVE) {
      data.removeWhere((key, value) => value['Usuario'] != auth.uid);
    }
    for (String key in data.keys) {
      Laboratorio lab = await getLab(data[key]['Laboratorio']);
      User user = await auth.getUser(data[key]['Usuario']);
      _items.add(
        Reserve(
          id: key,
          laboratorio: lab,
          usuario: user,
          status:
              type == Constants.RESERVE ? Constants.PENDING : Constants.APPROVE,
          horario: DateTime.parse(data[key]['Horario']),
          duracao: Duration(seconds: data[key]['Duracao']),
          integrantes: [],
        ),
      );
    }
    notifyListeners();
  }

  Future<Laboratorio> getLab(String labId) async {
    String query =
        '${Constants.laboratorios_URL}.json?auth=$_token&orderBy="\$key"&startAt="' +
            labId +
            '"&endAt="' +
            labId +
            '"';
    final response = await http.get(
      Uri.parse(query),
    );
    final laboratorio = jsonDecode(response.body)[labId];
    return Laboratorio(
      id: labId,
      nome: laboratorio['Nome'],
      campus: laboratorio['Campus'],
      descricao: laboratorio['Descricao'],
      urlImagem: laboratorio['UrlImagem'],
      chaveNFC: laboratorio['chaveNFC'],
    );
  }

  void updateLoading(bool bool) {
    _isLoading = bool;
    notifyListeners();
  }

  Future<void> saveItem(
      BuildContext context, String type, Reserve reserve) async {
    _isLoading = true;
    Auth auth = Provider.of(context, listen: false);
    if (auth.isAdmin == null) {
      await auth.setUserData(auth.uid);
    }
    if (!auth.isAdmin!) {
      return;
    }
    final response = await http.patch(
      Uri.parse('${Constants.reservas_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          reserve.id + '/Status': type,
        },
      ),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['error'] != null) {
      throw Exception(data['error']['message']);
    } else {
      int index = _items.indexOf(reserve);
      _items[index].status = type;
    }
  }
}
