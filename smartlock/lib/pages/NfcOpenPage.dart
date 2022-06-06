import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/mqttservice.dart';
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
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var availability = await FlutterNfcKit.nfcAvailability;
                    if (availability != NFCAvailability.available) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('NFC desligado'),
                          content: Text('Ative-o em seu smartphone'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
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
                        timeout: Duration(seconds: 10),
                        iosMultipleTagMessage: "Multiple tags found!",
                        iosAlertMessage: "Scan your tag");

                    if (laboratorio.chaveNFC == tag.id) {
                      print("tag correta");
                      Provider.of<mqttservice>(context, listen: false)
                          .connect(laboratorio.Nome);

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Acesso Concluído'),
                          content: Text(''),
                          actions: [
                            TextButton(
                              child: Text('OK'),
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
                          title: Text('Acesso Negado'),
                          content: Text(''),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                      print("tag errada");
                    }
                    print(jsonEncode(tag));

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
                  child: Text('Abrir'),
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
