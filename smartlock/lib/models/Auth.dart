import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartlock/exceptions/AuthException.dart';
import 'package:smartlock/models/User.dart';
import 'package:smartlock/models/UserData.dart';
import 'package:smartlock/utils/Constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _uid;
  String? _campus;
  DateTime? _expireDate;
  bool? _isAdmin;

  bool get isAuth {
    final isValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  String? get campus {
    return isAuth ? _campus : null;
  }

  bool? get isAdmin {
    return isAuth ? _isAdmin : null;
  }

  Future<void> _authenticate(
      String email, String password, String campus, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyC9hEPRwdGuOZGX0k85CS9zNq0xXqSmOHQ';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];
      _expireDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
      if (urlFragment == 'signUp') {
        final responseSignUp = await http.put(
          Uri.parse('${Constants.usuarios_URL}/$_uid.json?auth=$_token'),
          body: jsonEncode(
            {
              "campus": campus,
              "admin": false,
            },
          ),
        );
        final bodySignUp = jsonDecode(responseSignUp.body);
        if (bodySignUp['error'] != null) {
          throw AuthException(bodySignUp['error']['message']);
        } else {
          _campus = bodySignUp['campus'];
          _isAdmin = bodySignUp['admin'];
        }
      }
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String campus) async {
    return _authenticate(email, password, campus, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, '', 'signInWithPassword');
  }

  Future<UserData> getUserData(String? uId) async {
    final response = await http.get(
      Uri.parse('${Constants.usuarios_URL}/$uId.json?auth=$_token'),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    return UserData(
        id: data['id'] ?? uid,
        isAdmin: data['admin'],
        campus: data['campus'],
        agendamento: data['agendamento']);
    //requisicoes = data['requisicoes']; // historico
  }

  Future<void> setUserData(String? uId) async {
    UserData userData = await getUserData(uId);
    _uid = _uid ?? userData.id;
    _campus = _campus ?? userData.campus;
    _isAdmin = _isAdmin ?? userData.isAdmin;
  }

  Future<User> getUser(String? uId) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyC9hEPRwdGuOZGX0k85CS9zNq0xXqSmOHQ';

    final userResponse = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'idToken': _token,
        'localId': uid,
      }),
    );

    Map<String, dynamic> data = jsonDecode(userResponse.body);
    UserData userLab = await getUserData(uId);
    return User(
      id: data['users'][0]['localId'],
      token: token!,
      campus: userLab.campus,
      email: data['users'][0]['email'],
      nome: data['users'][0]['displayName'],
    );
  }
}
