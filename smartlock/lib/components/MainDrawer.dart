import 'package:flutter/material.dart';
import 'package:smartlock/utils/app_routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem vindo Usuário!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Adicionar Laboratório'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.LabAdd,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
