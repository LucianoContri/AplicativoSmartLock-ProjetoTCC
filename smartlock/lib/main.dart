import 'package:flutter/material.dart';
import 'package:smartlock/components/LabList.dart';
import 'package:smartlock/components/MqttService.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/pages/AuthOrHome.dart';
import 'package:smartlock/pages/LabAddPage.dart';
import 'package:smartlock/pages/LabApprovePage.dart';
import 'package:smartlock/pages/LabOpenPage.dart';
import 'package:smartlock/pages/LabReservePage.dart';
import 'package:smartlock/pages/NfcOpenPage.dart';
import 'utils/AppRoutes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, LabList>(
            create: (_) => LabList('', []),
            update: (ctx, auth, previous) {
              return LabList(
                auth.token ?? '',
                previous?.items ?? [],
              );
            }),
        ChangeNotifierProvider(
          create: (_) => MqttService(),
        ),
        ChangeNotifierProxyProvider<Auth, RequestList>(
          create: (_) => RequestList('', []),
          update: (ctx, auth, previous) {
            return RequestList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
          routes: {
            AppRoutes.authOrHome: (ctx) => AuthOrHome(),
            AppRoutes.labOpen: (ctx) => LabOpenPage(),
            AppRoutes.nfcOpen: (ctx) => NfcOpenPage(),
            AppRoutes.labAdd: (ctx) => LabAddPage(),
            AppRoutes.labReserve: (ctx) => LabReservePage(),
            AppRoutes.labApprove: (ctx) => LabApprovePage(),
          },
          theme: tema.copyWith(
              colorScheme: tema.colorScheme.copyWith(
                primary: const Color.fromARGB(255, 34, 199, 169),
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
