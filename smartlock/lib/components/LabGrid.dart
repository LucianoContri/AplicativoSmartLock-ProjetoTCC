import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/components/LabItem.dart';
import 'package:smartlock/components/LabList.dart';
import 'package:smartlock/models/Reserve.dart';
import 'package:smartlock/models/User.dart';
import 'package:smartlock/utils/AppRoutes.dart';
import 'package:smartlock/utils/Constants.dart';

class LabGrid extends StatelessWidget {
  final String origin;
  const LabGrid({Key? key, required this.origin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Reserve> loadedProducts;
    final provider;
    bool isLoading;
    if (origin == Constants.RESERVE) {
      provider = Provider.of<LabList>(context);
      loadedProducts = [];
      for (Laboratorio i in provider.items as List<Laboratorio>) {
        loadedProducts.add(Reserve(
            id: '',
            laboratorio: i,
            usuario: User(id: '', token: '', campus: '', email: ''),
            horario: DateTime.now(),
            status: '',
            duracao: Duration.zero,
            integrantes: []));
      }
    } else {
      provider = Provider.of<RequestList>(context);
      loadedProducts = provider.items as List<Reserve>;
    }
    loadedProducts = provider.items;
    isLoading = provider.isLoading;
    return isLoading
        ? const Center(
            heightFactor: 3,
            child: SizedBox(
                width: 200, height: 200, child: CircularProgressIndicator()))
        : loadedProducts.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
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
                        height: 150,
                        child: Image.asset(
                          'assets/images/noLabsFound.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.authOrHome,
                            (Route<dynamic> route) => false);
                      },
                      child: const Text("Atualizar"),
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                ],
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: loadedProducts.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: (origin == Constants.RESERVE)
                        ? loadedProducts[i]
                        : loadedProducts[i].laboratorio,
                    child: LabItem(
                      reserve: (origin == Constants.RESERVE)
                          ? null
                          : loadedProducts[i],
                      laboratorio: loadedProducts[i].laboratorio,
                      origin: origin,
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
