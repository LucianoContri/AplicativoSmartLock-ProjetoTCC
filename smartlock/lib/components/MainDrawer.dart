import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/utils/AppRoutes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuário!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Meus agendamentos'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.authOrHome, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Agendar horário'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.labReserve,
              );
            },
          ),
          if (auth.isAdmin!)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Adicionar Laboratório'),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.labAdd,
                );
              },
            ),
          if (auth.isAdmin!)
            ListTile(
              leading: const Icon(Icons.checklist_rtl_sharp),
              title: const Text('Aprovar requisições'),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.labApprove,
                );
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          ),
        ],
      ),
    );
  }
}
