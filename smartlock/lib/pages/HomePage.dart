import 'package:flutter/material.dart';

import '../components/LabList.dart';
import '../data/dadosdeteste.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [LabList(LaboratoriosIESB)],
      ),
    );
  }
}
