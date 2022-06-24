import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/MqttService.dart';
import 'package:smartlock/models/Labs.dart';

class NfcOpenPage extends StatefulWidget {
  const NfcOpenPage({Key? key}) : super(key: key);

  @override
  State<NfcOpenPage> createState() => _NfcOpenPageState();
}

class _NfcOpenPageState extends State<NfcOpenPage> {
  @override
  Widget build(BuildContext context) {
    final Laboratorio laboratorio =
        ModalRoute.of(context)!.settings.arguments as Laboratorio;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 50),
          const Text('Aproxime o seu celular da fechadura',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 74, 57),
                fontSize: 20,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var availability = await FlutterNfcKit.nfcAvailability;
                    if (availability != NFCAvailability.available) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('NFC desligado'),
                          content: const Text('Ative-o em seu smartphone'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
// timeout only works on Android, while the latter two messages are only for iOS
                    var tag = await FlutterNfcKit.poll(
                        timeout: const Duration(seconds: 10),
                        iosMultipleTagMessage: "Multiple tags found!",
                        iosAlertMessage: "Scan your tag");

                    if (laboratorio.chaveNFC == tag.id) {
                      Provider.of<MqttService>(context, listen: false)
                          .connect(laboratorio.nome);

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Acesso Concluído'),
                          content: const Text(''),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Acesso Negado'),
                          content: const Text(''),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }

// write NDEF records if applicable
                    // if (tag.ndefWritable!) {
                    //   // decoded NDEF records
                    // await FlutterNfcKit.writeNDEFRecords([
                    //   ndef.TextRecord(text: 'opa'),
                    // ]);
                    // raw NDEF records
                    // await FlutterNfcKit.writeNDEFRawRecords([
                    //   new NDEFRawRecord(
                    //       "00", "0001", "0002", ndef.TypeNameFormat.unknown)
                    // ]);
                  },
                  child: const Text('Abrir'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 200),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          const Text('Powered by NFC™',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 74, 57),
                fontSize: 17,
              )),
        ],
      ),
    );
  }
}
