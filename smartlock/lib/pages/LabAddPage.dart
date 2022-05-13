import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/components/LabList.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   _imageUrlFocus.addListener(updateImage);
  // }as

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
    final newlab = Laboratorio(
      id: Random().nextDouble().toString(),
      Nome: _formData['Nome'] as String,
      Campus: _formData['Campus'] as String,
      Descricao: _formData['Descricao'] as String,
      UrlImagem: _formData['UrlImagem'] as String,
      chaveNFC: _formData['chaveNFC'] as String,
    );

    Provider.of<LabList>(
      context,
      listen: false,
    ).AddLab(newlab);

    Navigator.of(context).pop();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                focusNode: _NomeFocus,
                onSaved: (Nome) => _formData['Nome'] = Nome ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                textInputAction: TextInputAction.next,
                focusNode: _DescricaoFocus,
                onSaved: (Descricao) =>
                    _formData['Descricao'] = Descricao ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Campus'),
                textInputAction: TextInputAction.next,
                focusNode: _CampusFocus,
                onSaved: (Campus) => _formData['Campus'] = Campus ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Chave NFC'),
                textInputAction: TextInputAction.next,
                focusNode: _ChaveNFCFocus,
                onSaved: (chaveNFC) => _formData['chaveNFC'] = chaveNFC ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Url Imagem'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                focusNode: _imageUrlFocus,
                onSaved: (UrlImagem) =>
                    _formData['UrlImagem'] = UrlImagem ?? '',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Adicionar'),
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
