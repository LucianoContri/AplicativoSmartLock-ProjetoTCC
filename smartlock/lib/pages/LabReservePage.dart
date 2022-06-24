import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/LabGrid.dart';
import 'package:smartlock/components/LabList.dart';
import 'package:smartlock/models/Auth.dart';
import 'package:smartlock/models/Campus.dart';
import 'package:diacritic/diacritic.dart';
import 'package:smartlock/utils/Constants.dart';

class LabReservePage extends StatefulWidget {
  const LabReservePage({Key? key}) : super(key: key);

  @override
  State<LabReservePage> createState() => _LabReservePageState();
}

class _LabReservePageState extends State<LabReservePage> {
  final _CampusFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _CampusFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    Auth auth = Provider.of(context, listen: false);
    _refreshProducts(context, campus: auth.campus);
  }

  Future<void> _refreshProducts(BuildContext context, {String? campus}) async {
    final provider = Provider.of<LabList>(
      context,
      listen: false,
    );
    return provider
        .loadProducts(context, campus: campus)
        .then((value) => provider.updateLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    List<String> campusAdm = Campus.display;
    Auth auth = Provider.of(context, listen: false);
    if (auth.isAdmin!) {
      campusAdm.add(Constants.allLabsAdmin);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Laboratório'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField(
                  items: campusAdm.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: auth.isAdmin!
                      ? (String? newValue) {
                          String? campus = newValue == Constants.allLabsAdmin
                              ? newValue
                              : Campus.values.firstWhere((e) =>
                                  e.toString().toUpperCase() ==
                                  removeDiacritics(newValue!).toUpperCase());
                          _refreshProducts(context, campus: campus);
                        }
                      : null,
                  value: Campus.display
                      .singleWhere((e) => e.toUpperCase() == auth.campus),
                  focusNode: _CampusFocus,
                  decoration:
                      const InputDecoration(labelText: 'Selecione o campus'),
                ),
                LabGrid(origin: Constants.Reserve),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
