import 'package:flutter/material.dart';

class LabAddPage extends StatefulWidget {
  const LabAddPage({Key? key}) : super(key: key);

  @override
  State<LabAddPage> createState() => _LabAddPageState();
}

class _LabAddPageState extends State<LabAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário do Laboratório'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
