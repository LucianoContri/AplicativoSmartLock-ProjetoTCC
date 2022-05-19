import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

import 'package:http/http.dart';

class NfcOpenPage extends StatefulWidget {
  const NfcOpenPage({Key? key}) : super(key: key);

  @override
  State<NfcOpenPage> createState() => _NfcOpenPageState();
}

class _NfcOpenPageState extends State<NfcOpenPage> {
  String _platformVersion = 'Unknown';
  bool _started = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            fixedSize: const Size(100, 100),
            shape: const CircleBorder(),
          ),
        ),
      ),
    );
  }
}
