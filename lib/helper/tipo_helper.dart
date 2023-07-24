import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/helper/Databases.dart';

class TipoHelper {
  static final TipoHelper _instance = TipoHelper.internal();

  factory TipoHelper() => _instance;

  TipoHelper.internal();

  Databases databases = new Databases();

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }
}

class Tipo {
  dynamic id;
  String type;

  Tipo({this.id, this.type});

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(id: json['id'], type: json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }

  @override
  String toString() {
    return "Tipo(id: $id, type: $type)";
  }
}
