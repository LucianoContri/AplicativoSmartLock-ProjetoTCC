import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/models/Campus.dart';
import 'package:smartlock/models/Reserve.dart';
import 'package:smartlock/utils/AppRoutes.dart';
import 'package:smartlock/utils/Constants.dart';

class ReserveItem extends StatelessWidget {
  final Reserve request;
  const ReserveItem({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestList>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Container(
          padding: const EdgeInsets.all(13.0),
          constraints: const BoxConstraints.expand(),
          //width: double.infinity,
          child: Container(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/class.png', height: 30.0),
                          Container(width: 5.0),
                          const Text('Laboratório:',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      Container(height: 5.0),
                      Row(
                        children: [
                          const Text("Nome:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          Container(width: 5.0),
                          Text(request.laboratorio.nome,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Container(height: 5.0),
                      Row(
                        children: [
                          const Text("Campus:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          Container(width: 5.0),
                          Text(
                              Campus.display.firstWhere((e) =>
                                  e.toUpperCase() ==
                                  request.laboratorio.campus.toUpperCase()),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Container(height: 5.0),
                      Row(
                        children: [
                          const Text("Descrição:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          Container(width: 5.0),
                          Text(request.laboratorio.descricao,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Container(height: 5.0),
                      const Text("Data:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                      Container(width: 5.0),
                      Text(
                          DateFormat('dd-MM-yyyy - hh:mm')
                              .format(request.horario),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 15,
                          )),
                      Container(height: 5.0),
                      const Text("Duração total:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                      Container(width: 5.0),
                      Text(
                          request.duracao.inHours.toString() +
                              ' hora(s) e ' +
                              request.duracao.inMinutes.toString() +
                              ' minuto(s).',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 15,
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/user.png', height: 30.0),
                          Container(width: 5.0),
                          const Text(
                            'Usuário requerente:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(height: 5.0),
                      Text(request.usuario.email,
                          overflow: TextOverflow.ellipsis),
                      Container(height: 5.0),
                    ],
                  ),
                ],
              ),
              Container(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      provider
                          .saveItem(context, Constants.REFUSED, request)
                          .then((value) {
                        provider.updateLoading(false);
                        Navigator.of(context).pushNamed(AppRoutes.labApprove);
                      });
                    },
                    child: const Text('Recusar requisição'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.blue,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provider
                          .saveItem(context, Constants.ACCEPTED, request)
                          .then((value) {
                        provider.updateLoading(false);
                        Navigator.of(context).pushNamed(AppRoutes.labApprove);
                      });
                    },
                    child: const Text('Aprovar requisição'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shadowColor: Colors.green,
                      elevation: 8,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(195, 218, 251, 255),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
        ),
        footer: Column(),
      ),
    );
  }
}
