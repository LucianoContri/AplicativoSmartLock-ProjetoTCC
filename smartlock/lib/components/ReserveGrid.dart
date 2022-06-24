import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/components/ReserveItem.dart';
import 'package:smartlock/models/Reserve.dart';

class ReserveGrid extends StatelessWidget {
  const ReserveGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestList>(context);
    final List<Reserve> loadedProducts = provider.items;
    return provider.isLoading
        ? const Center(
            heightFactor: 3,
            child: SizedBox(
                width: 200, height: 200, child: CircularProgressIndicator()))
        : loadedProducts.isEmpty
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
                        'Nenhuma reserva para atendimento!',
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
                          'assets/images/noLabsFound.png',
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
                    child: ReserveItem(
                      request: loadedProducts[i],
                    ),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.33,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              );
  }
}
