import 'dart:io';

import 'package:dio_lista_contatos/models/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContatosPage extends StatefulWidget {
  const ContatosPage({super.key});

  @override
  State<ContatosPage> createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  late final Box<Contato> box;

  @override
  void initState() {
    super.initState();

    box = Hive.box('imcBox');
  }

  void clearBox() {
    box.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text('Lista de contatos'),
        actions: [
          IconButton(
              tooltip: 'Limpar lista',
              onPressed: clearBox,
              icon: const Icon(Icons.cleaning_services_outlined))
        ],
      ),
      body: ValueListenableBuilder<Box<Contato>>(
          valueListenable: box.listenable(),
          builder: (_, contatoBox, __) {
            if (contatoBox.isEmpty) {
              return const Center(
                child: Text('Nenhum contato registrado'),
              );
            }

            return ListView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (_, index) {
                  final contato = contatoBox.getAt(index);
                  return _ContatoCard(contato!);
                });
          }),
    ));
  }
}

class _ContatoCard extends StatelessWidget {
  const _ContatoCard(this.contato);

  final Contato contato;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundImage: Image.file(File(contato.imgPath!)).image,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nome: ${contato.nome}'),
                const SizedBox(height: 4),
                Text('Telefone: ${contato.telefone}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
