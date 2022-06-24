import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/LabList.dart';
import 'package:smartlock/models/Campus.dart';
import 'package:smartlock/models/Labs.dart';

class LabAddPage extends StatefulWidget {
  const LabAddPage({Key? key}) : super(key: key);

  @override
  State<LabAddPage> createState() => _LabAddPageState();
}

class _LabAddPageState extends State<LabAddPage> {
  final _NomeFocus = FocusNode();
  final _DescricaoFocus = FocusNode();
  final _CampusFocus = FocusNode();
  final _ChaveNFCFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _formkey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void dispose() {
    super.dispose();
    _NomeFocus.dispose();
    _DescricaoFocus.dispose();
    _CampusFocus.dispose();
    _ChaveNFCFocus.dispose();
    _imageUrlFocus.dispose();
  }

  void _submitForm() {
    _formkey.currentState?.save();
    String campus = Campus.values.firstWhere((e) =>
        e.toString().toUpperCase() ==
        removeDiacritics(_formData['Campus'].toString()).toUpperCase());
    final newlab = Laboratorio(
      id: Random().nextDouble().toString(),
      nome: _formData['Nome'] as String,
      campus: campus,
      descricao: _formData['Descricao'] as String,
      urlImagem: _formData['UrlImagem'] as String,
      chaveNFC: _formData['chaveNFC'] as String,
    );

    Provider.of<LabList>(
      context,
      listen: false,
    ).addLab(newlab);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário do Laboratório'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                focusNode: _NomeFocus,
                onSaved: (nome) => _formData['Nome'] = nome ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                textInputAction: TextInputAction.next,
                focusNode: _DescricaoFocus,
                onSaved: (descricao) =>
                    _formData['Descricao'] = descricao ?? '',
              ),
              DropdownButtonFormField(
                items: Campus.display.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState() {}
                },
                focusNode: _CampusFocus,
                onSaved: (campus) => _formData['Campus'] = campus ?? '',
                decoration: const InputDecoration(labelText: 'Campus'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Chave NFC'),
                textInputAction: TextInputAction.next,
                focusNode: _ChaveNFCFocus,
                onSaved: (chaveNFC) => _formData['chaveNFC'] = chaveNFC ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Url Imagem'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                focusNode: _imageUrlFocus,
                onSaved: (urlImagem) =>
                    _formData['UrlImagem'] = urlImagem ?? '',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 40),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
