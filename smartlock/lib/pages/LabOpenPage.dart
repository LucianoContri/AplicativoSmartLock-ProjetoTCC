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
              color: Color.fromARGB(255, 34, 199, 169),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(laboratorio.Nome,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  Text(laboratorio.Descricao,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.NfcOpen);
              },
              child: Text('Abrir'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 100),
                shape: const CircleBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
