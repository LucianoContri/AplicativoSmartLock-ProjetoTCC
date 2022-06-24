import 'package:flutter/material.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/models/Reserve.dart';
import 'package:smartlock/utils/AppRoutes.dart';
import 'package:smartlock/utils/Constants.dart';
import 'package:smartlock/utils/LabArguments.dart';

class LabItem extends StatelessWidget {
  final Reserve? reserve;
  final Laboratorio? laboratorio;
  final String? origin;
  const LabItem({
    Key? key,
    this.reserve,
    this.laboratorio,
    this.origin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Laboratorio? lab = reserve == null ? laboratorio : reserve!.laboratorio;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            lab!.urlImagem,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.labOpen,
                arguments: LabArguments(laboratorio, reserve, origin));
          },
        ),
        footer: GridTileBar(
          title: Text(lab.nome),
          trailing: IconButton(
            onPressed: () {},
            icon: origin == Constants.reserve
                ? const Icon(Icons.add_circle_outline_outlined)
                : const Icon(Icons.key),
          ),
          backgroundColor: const Color.fromARGB(255, 34, 199, 169),
        ),
      ),
    );
  }
}
