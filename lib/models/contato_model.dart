import 'package:hive_flutter/hive_flutter.dart';

part 'contato_model.g.dart';

@HiveType(typeId: 0)
class Contato {
  const Contato({
    required this.nome,
    required this.telefone,
    this.imgPath,
  });

  @HiveField(0)
  final String nome;

  @HiveField(1)
  final String telefone;

  @HiveField(2)
  final String? imgPath;
}
