import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/models/Campus.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/models/Reserve.dart';
import 'package:smartlock/models/User.dart';
import 'package:smartlock/utils/Constants.dart';
import 'package:smartlock/utils/LabArguments.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:intl/intl.dart';

import '../utils/AppRoutes.dart';

class LabOpenPage extends StatelessWidget {
  const LabOpenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _DateController = TextEditingController();
    final deviceSize = MediaQuery.of(context).size;
    final LabArguments args =
        ModalRoute.of(context)!.settings.arguments as LabArguments;
    final Laboratorio? lab =
        args.reserve == null ? args.laboratorio : args.reserve!.laboratorio;
    final String? origin = args.origin;
    final Reserve? reserve = args.reserve;
    final provider = Provider.of<RequestList>(context);
    Auth auth = Provider.of<Auth>(context);
    DateTime? _horario;
    Duration? _duracao;
    TimeOfDay? _picked;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lab!.nome,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              lab.urlImagem,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Campus ${Campus.display.firstWhere((e) => e.toUpperCase() == lab.campus.toUpperCase())}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      )),
                  Text(lab.descricao,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            SizedBox(
                height: origin == Constants.reserve
                    ? MediaQuery.of(context).size.height * 0.03
                    : MediaQuery.of(context).size.height * 0.15),
            if (origin == Constants.reserve)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      onChanged: (String? newValue) {
                        setState() {
                          newValue ?? '';
                        }
                      },
                      keyboardType: TextInputType.none,
                      decoration:
                          const InputDecoration(labelText: 'Data da reserva:'),
                      textInputAction: TextInputAction.next,
                      onTap: () async {
                        _horario = await showDatePicker(
                            context: context,
                            initialDate: _horario ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(
                                DateTime.now().year, DateTime.december, 31));
                        if (_horario == null) {
                          _DateController.text =
                              'Selecione uma data e a duração da reserva:';
                          return;
                        }
                        _picked = await showTimePicker(
                            context: context,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child ?? Container(),
                              );
                            },
                            initialTime: TimeOfDay.fromDateTime(
                                _horario ?? DateTime.now()));
                        if (_horario == null || _picked == null) {
                          _DateController.text =
                              'Selecione uma data e a duração da reserva:';
                          return;
                        }
                        _horario = _horario?.add(Duration(
                            hours: _picked!.hour, minutes: _picked!.minute));

                        _duracao = await showDurationPicker(
                            context: context,
                            initialTime: _duracao ??
                                const Duration(hours: 00, minutes: 00));
                        if (_horario == null ||
                            _picked == null ||
                            _duracao == null) {
                          _DateController.text =
                              'Selecione uma data e a duração da reserva:';
                          return;
                        } else {
                          _DateController.text =
                              DateFormat('dd-MM-yyyy – kk:mm')
                                      .format(_horario!) +
                                  ' durante ' +
                                  _duracao!.inHours.toString() +
                                  ' hora(s) e ' +
                                  _duracao!.inMinutes.toString() +
                                  ' minuto(s).';
                        }
                      },
                      controller: _DateController,
                      validator: (value) {
                        if (_horario == null ||
                            _duracao == null ||
                            value!.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            Container(
              height: deviceSize.width * 0.25,
              width: deviceSize.width * 0.70,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: ElevatedButton(
                onPressed: origin == Constants.reserve
                    ? () async {
                        User user = await auth.getUser(auth.uid);
                        provider.reserveLab(
                            lab, _duracao!, _horario!, [], user);
                        Navigator.of(context).pushNamed(
                          AppRoutes.authOrHome,
                        );
                      }
                    : () {
                        if (origin == Constants.approve &&
                            reserve != null &&
                            DateTime.now().isAfter(reserve.horario
                                .subtract(const Duration(minutes: 15))) &&
                            DateTime.now().isBefore(reserve.horario.add(
                                Duration(
                                    hours: reserve.duracao.inHours,
                                    minutes: reserve.duracao.inMinutes)))) {
                          Navigator.of(context).pushNamed(
                            AppRoutes.nfcOpen,
                            arguments: lab,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text(
                                  'Laboratório indisponível no momento.'),
                              content: const Text(
                                  'Somente é possível acessar o laboratório 15 minutos antes da reserva.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Fechar'),
                                )
                              ],
                            ),
                          );
                        }
                      },
                child: origin == Constants.reserve
                    ? const Text('Reservar')
                    : const Text('Acessar'),
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
