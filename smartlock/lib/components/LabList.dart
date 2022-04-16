import 'package:flutter/material.dart';
import 'package:smartlock/models/Labs.dart';

class LabList extends StatelessWidget {
  final List<Laboratorio> Laboratorios;

  LabList(this.Laboratorios);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      child: Laboratorios.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Nenhum Laboratório disponível!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/RcGRy7K7i.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          : ListView.builder(
              itemCount: Laboratorios.length,
              itemBuilder: (ctx, index) {
                final tr = Laboratorios[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              tr.UrlImagem,
                              width: 200,
                              height: 200,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FittedBox(
                              child: Text(
                                tr.Nome,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                tr.Descricao,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 94, 94, 94)),
                              ),
                            ),
                          ],
                        ),
                      ]),
                );
              },
            ),
    );
  }
}
