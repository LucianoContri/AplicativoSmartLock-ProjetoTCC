import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/pages/AuthScreen.dart';
import 'package:smartlock/pages/HomePage.dart';

import '../models/Auth.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return auth.isAuth ? HomePage() : AuthScreen();
  }
}
