import 'package:flutter/material.dart';
import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/pages/LabOpenPage.dart';
import 'package:smartlock/utils/app_routes.dart';

class LabItem extends StatelessWidget {
  final Laboratorio lab;
  const LabItem({
    Key? key,
    required this.lab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            lab.UrlImagem,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.LabOpen,
              arguments: lab,
            );
          },
        ),
        footer: GridTileBar(
          title: Text(lab.Nome),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.key),
          ),
          backgroundColor: Color.fromARGB(255, 34, 199, 169),
        ),
      ),
    );
  }
}
