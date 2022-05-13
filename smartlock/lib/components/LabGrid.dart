import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/components/LabItem.dart';
import 'package:smartlock/components/LabList.dart';

class LabGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LabList>(context);
    final List<Laboratorio> loadedProducts = provider.items;
    return Container(
        height: 800,
        child: loadedProducts.isEmpty
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
            : GridView.builder(
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
              ));
  }
}
