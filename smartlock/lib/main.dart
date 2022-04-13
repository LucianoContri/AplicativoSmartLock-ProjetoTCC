import 'package:flutter/material.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/pages/AuthOrHome.dart';
import 'package:smartlock/pages/AuthScreen.dart';
import 'package:smartlock/pages/HomePage.dart';
import 'utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData Tema = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
          routes: {
            AppRoutes.AuthOrHome: (ctx) => AuthOrHome(),
          },
          theme: Tema.copyWith(
              colorScheme: Tema.colorScheme.copyWith(
                primary: Color.fromARGB(255, 34, 199, 169),
                secondary: Colors.red,
              ),
              // textTheme: Tema.textTheme.copyWith(
              //     headline6: const TextStyle(
              //   fontFamily: 'OpenSans',
              //   fontSize: 18,
              //   fontWeight: FontWeight.bold,
              //   color: Colors.black,
              // )),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                centerTitle: true,
                // titleTextStyle: TextStyle(
                //   fontFamily: 'OpenSans',
                //   fontSize: 20,
                //   fontWeight: FontWeight.bold,
                // ),
              ))),
    );
  }
}
