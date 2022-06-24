import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/MainDrawer.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/utils/AppRoutes.dart';
import 'package:smartlock/utils/Constants.dart';
import '../components/LabGrid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    _refreshProducts(context);
  }

  Future<void> _refreshProducts(BuildContext context) {
    final provider = Provider.of<RequestList>(
      context,
      listen: false,
    );
    return provider
        .loadReserves(context, Constants.APPROVE)
        .then((value) => provider.updateLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus agendamentos',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<Auth>(
                  context,
                  listen: false,
                ).logout();
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.authOrHome,
                );
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [LabGrid(origin: Constants.APPROVE)],
            ),
          ),
        ),
      ),
    );
  }
}
