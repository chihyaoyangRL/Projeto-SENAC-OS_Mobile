import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/helper/Databases.dart';

class Cadastro_PedidoHelper {
  static final Cadastro_PedidoHelper _instance =
      Cadastro_PedidoHelper.internal();

  factory Cadastro_PedidoHelper() => _instance;

  Cadastro_PedidoHelper.internal();

  Databases databases = new Databases();

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }
}

class Cadastro_Pedido {
  dynamic id;
  dynamic cd_cliente;
  dynamic cd_tipo;
  dynamic cd_status;
  dynamic cd_funcionario;
  String marca;
  String modelo;
  String defeito;
  String descricao;

  //Rename inner join
  String Cliente;
  String Tipo;
  String Status;
  String Funcionario;
  dynamic data_pedido;

  Cadastro_Pedido(
      {this.id,
      this.cd_cliente,
      this.cd_tipo,
      this.cd_status,
      this.cd_funcionario,
      this.marca,
      this.modelo,
      this.defeito,
      this.descricao,
      //Rename inner join
      this.Cliente,
      this.Tipo,
      this.Status,
      this.Funcionario,
      this.data_pedido});

  factory Cadastro_Pedido.fromJson(Map<String, dynamic> json) {
    return Cadastro_Pedido(
        id: json['id'],
        cd_cliente: json['cd_cliente'],
        cd_tipo: json['cd_tipo'],
        cd_status: json['cd_status'],
        cd_funcionario: json['cd_funcionario'],
        marca: json['marca'],
        modelo: json['modelo'],
        defeito: json['defeito'],
        descricao: json['descricao'],
        //Rename inner join
        Cliente: json['Cliente'],
        Tipo: json['Tipo'],
        Status: json['Status'],
        Funcionario: json['Funcionario'],
        data_pedido: json['data_pedido']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cd_cliente'] = this.cd_cliente;
    data['cd_tipo'] = this.cd_tipo;
    data['cd_status'] = this.cd_status;
    data['cd_funcionario'] = this.cd_funcionario;
    data['marca'] = this.marca;
    data['modelo'] = this.modelo;
    data['defeito'] = this.defeito;
    data['descricao'] = this.descricao;
    //Rename inner join
    data['Cliente'] = this.Cliente;
    data['Tipo'] = this.Tipo;
    data['Status'] = this.Status;
    data['Funcionario'] = this.Funcionario;
    data['data_pedido'] = this.data_pedido;
    return data;
  }

  @override
  String toString() {
    return "Cadastro_Pedido(id: $id, cd_cliente: $cd_cliente, cd_tipo: $cd_tipo, cd_status: $cd_status, cd_funcionario: $cd_funcionario, marca: $marca, modelo: $modelo, defeito: $defeito, descricao: $descricao,Cliente: $Cliente,Tipo: $Tipo,Status: $Status,Funcionario: $Funcionario, data_pedido: $data_pedido)";
  }
}
