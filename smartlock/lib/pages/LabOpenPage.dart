import 'package:flutter/material.dart';
import 'package:smartlock/models/Labs.dart';

import '../utils/app_routes.dart';

class LabOpenPage extends StatelessWidget {
  const LabOpenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Laboratorio laboratorio =
        ModalRoute.of(context)!.settings.arguments as Laboratorio;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          laboratorio.Nome,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network(
                laboratorio.UrlImagem,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Campus ${laboratorio.Campus}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      )),
                  Text(laboratorio.Descricao,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.NfcOpen,
                  arguments: laboratorio,
                );
              },
              child: Text('Abrir'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 150),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
