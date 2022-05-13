import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/LabList.dart';
import '../components/LabGrid.dart';
import '../data/dadosdeteste.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        title: const Text(
          'Laboratórios',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: Column(
        children: [LabGrid()],
      ),
    );
  }
}
