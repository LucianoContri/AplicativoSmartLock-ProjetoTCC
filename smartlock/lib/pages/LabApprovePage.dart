import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/RequestList.dart';
import 'package:smartlock/components/ReserveGrid.dart';
import 'package:smartlock/utils/AppRoutes.dart';
import 'package:smartlock/utils/Constants.dart';

class LabApprovePage extends StatefulWidget {
  const LabApprovePage({Key? key}) : super(key: key);

  @override
  State<LabApprovePage> createState() => _LabApprovePageState();
}

class _LabApprovePageState extends State<LabApprovePage> {
  void initState() {
    super.initState();
    _loadRequests(context);
  }

  Future<void> _loadRequests(BuildContext context) async {
    final provider = Provider.of<RequestList>(
      context,
      listen: false,
    );
    return provider
        .loadReserves(context, Constants.RESERVE)
        .then((value) => provider.updateLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.authOrHome, (Route<dynamic> route) => false),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Pedidos de Reservas'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadRequests(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [ReserveGrid()],
            ),
          ),
        ),
      ),
    );
  }
}
