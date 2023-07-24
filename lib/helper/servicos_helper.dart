import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/helper/Databases.dart';

class ServicosHelper {
  static final ServicosHelper _instance = ServicosHelper.internal();

  factory ServicosHelper() => _instance;

  ServicosHelper.internal();

  Databases databases = new Databases();

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }
}

class Servicos {
  dynamic id;
  String servico;
  dynamic precos;

  Servicos({this.id, this.servico, this.precos});

  factory Servicos.fromJson(Map<String, dynamic> json) {
    return Servicos(
        id: json['id'], servico: json['servico'], precos: json['precos']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['servico'] = this.servico;
    data['precos'] = this.precos;
    return data;
  }

  @override
  String toString() {
    return "Servicos(id: $id, servico: $servico, precos: $precos)";
  }
}
