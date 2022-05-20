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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var availability = await FlutterNfcKit.nfcAvailability;
                    if (availability != NFCAvailability.available) {
                      // oh-no
                      print('NFCOFF');
                    }
// timeout only works on Android, while the latter two messages are only for iOS
                    var tag = await FlutterNfcKit.poll(
                        timeout: Duration(seconds: 10),
                        iosMultipleTagMessage: "Multiple tags found!",
                        iosAlertMessage: "Scan your tag");
                    if (laboratorio.chaveNFC == tag.id) {
                      print("tag correta");
                      Provider.of<mqttservice>(context, listen: false)
                          .connect();
                    } else {
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
        ],
      ),
    );
  }
}
