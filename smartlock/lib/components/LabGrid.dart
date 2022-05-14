import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/components/LabItem.dart';
import 'package:smartlock/components/LabList.dart';

import '../data/dadosdeteste.dart';

class LabGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('entrou');
    final provider = Provider.of<LabList>(context);
    print('saiu');
    final List<Laboratorio> loadedProducts = provider.items;
    print(loadedProducts);
    return
        // Container(
        //     height: 800,
        //     child:
        loadedProducts.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nenhum Laboratório disponível!',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        child: Image.asset(
                          'assets/images/RcGRy7K7i.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  )
                ],
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: loadedProducts.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: loadedProducts[i],
                    child: LabItem(
                      lab: loadedProducts[i],
                    ),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              );
  }
}
