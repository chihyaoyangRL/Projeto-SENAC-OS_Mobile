import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/helper/Databases.dart';

class ClienteHelper {
  static final ClienteHelper _instance = ClienteHelper.internal();

  factory ClienteHelper() => _instance;

  ClienteHelper.internal();

  Databases databases = new Databases();

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }
}

class Cliente {
  dynamic id;
  String nome;
  String email;
  String password;
  String telefone;
  String cpf;
  dynamic status;

  Cliente(
      {this.id,
      this.nome,
      this.email,
      this.password,
      this.telefone,
      this.cpf,
      this.status});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      password: json['password'],
      telefone: json['telefone'],
      cpf: json['cpf'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['password'] = this.password;
    data['telefone'] = this.telefone;
    data['cpf'] = this.cpf;
    data['status'] = this.status;
    return data;
  }

  @override
  String toString() {
    return "Cliente(id: $id, nome: $nome, email: $email, password: $password, telefone: $telefone, cpf: $cpf, status: $status)";
  }
}
