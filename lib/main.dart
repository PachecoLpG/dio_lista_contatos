import 'dart:io';

import 'package:dio_lista_contatos/contatos_page.dart';
import 'package:dio_lista_contatos/models/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de contatos - DIO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  XFile? imgFile;
  String? imgPath;
  CroppedFile? croppedImg;
  late Box<Contato> contatosBox;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  void openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ContatoAdapter());
    }

    contatosBox = await Hive.openBox<Contato>('imcBox');
  }

  String? validadeNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe o nome';
    }

    if (value.length < 3) {
      return 'Informe um nome valido';
    }

    return null;
  }

  String? validateTelefone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe o telefone';
    }

    if (value.length < 9) {
      return 'Informe um telefone valido';
    }

    return null;
  }

  Future<void> adicionarImg() async {
    if (imgFile != null) {
      imgFile = null;
    }

    imgFile = await _picker.pickImage(source: ImageSource.camera);
    croppedImg = await ImageCropper()
        .cropImage(sourcePath: imgFile!.path, maxHeight: 1000, maxWidth: 1000);
    if (croppedImg == null) {
      return;
    }

    Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    XFile temp = XFile(croppedImg!.path);
    imgPath =
        '${appDocumentsDir.path}/${DateTime.now().millisecondsSinceEpoch}';
    await temp.saveTo(imgPath!);
  }

  Future<void> adicionarContato() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (imgFile == null || imgPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione uma imagem para prosseguir'),
        ),
      );

      return;
    }

    Contato contato = Contato(
        nome: nomeController.text,
        telefone: telefoneController.text,
        imgPath: imgPath);

    await contatosBox.add(contato);

    nomeController.clear();
    telefoneController.clear();
    setState(() {
      imgFile = null;
      imgPath = null;
      croppedImg = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato adicionado com sucesso'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nomeController,
                validator: (value) => validadeNome(value),
                decoration: const InputDecoration(
                    hintText: 'Informe o nome do contato'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: telefoneController,
                validator: (value) => validateTelefone(value),
                decoration:
                    const InputDecoration(hintText: 'Informe o telefone'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: adicionarImg,
                icon: const Icon(Icons.camera),
                label: const Text('Adicionar foto do contato'),
              ),
              if (imgFile != null) const SizedBox(height: 4),
              if (imgFile != null) const Text('Foto adicionada'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: adicionarContato,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar contato'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ContatosPage(),
                  ),
                ),
                icon: const Icon(Icons.list),
                label: const Text('Lista de contatos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
