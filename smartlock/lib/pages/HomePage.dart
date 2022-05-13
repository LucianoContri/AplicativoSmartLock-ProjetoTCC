import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/MainDrawer.dart';

import '../components/LabList.dart';
import '../components/LabGrid.dart';
import '../data/dadosdeteste.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    Provider.of<LabList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laboratórios',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [LabGrid()],
      ),
    );
  }
}
