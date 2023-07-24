import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/helper/servicos_helper.dart';
import 'package:ordem_services/helper/status_helper.dart';
import 'package:ordem_services/helper/tipo_helper.dart';
import 'package:ordem_services/helper/cadastro_pedido_helper.dart';
import 'package:ordem_services/helper/cliente_helper.dart';
import 'package:ordem_services/helper/funcionario_helper.dart';
import 'package:ordem_services/helper/item_pedido_helper.dart';

const BASE_URL = "http://senacsmo.educacao.ws/chih/rest/";

class Api {
  String token;

  Api({this.token});

///////////////////////////////////Login//////////////////////////////////////////////
  Future<Login> login(String email, String senha) async {
    http.Response response = await http.post(BASE_URL + "Login/login",
        body: jsonEncode({"password": senha, "email": email}),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Login dadosJson = new Login.fromMap(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<Login> loginPhone(String telefone) async {
    http.Response response = await http.post(BASE_URL + "Login/loginphone",
        body: jsonEncode({"telefone": telefone}),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Login dadosJson = new Login.fromMap(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<List<Funcionario>> getfuncionario() async {
    http.Response response = await http.get(BASE_URL + 'Funcionario',
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Funcionario> funcionarios =
          json.decode(response.body).map<Funcionario>((map) {
        return Funcionario.fromJson(map);
      }).toList();
      return funcionarios;
    } else {
      return null;
    }
  }

  Future<List<Funcionario>> getfuncionarioOne(String codigo) async {
    http.Response response = await http.get(BASE_URL + 'Funcionario/' + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Funcionario> func =
          json.decode(response.body).map<Funcionario>((map) {
        return Funcionario.fromJson(map);
      }).toList();
      return func;
    } else {
      return null;
    }
  }

///////////////////////////////////Funcionario//////////////////////////////////////////////
  Future<Funcionario> cadastrarFuncionario(Funcionario funcionario) async {
    http.Response response = await http.post(BASE_URL + "Login/cadastro",
        body: jsonEncode({
          "nome": funcionario.nome,
          "email": funcionario.email,
          "password": funcionario.password,
          "telefone": funcionario.telefone,
          "cpf": funcionario.cpf
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Funcionario dadosJson =
          new Funcionario.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<bool> deletarFuncionario(String codigoFuncionario) async {
    http.Response response = await http.delete(
        BASE_URL + "Funcionario/" + codigoFuncionario,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Funcionario> atualizarFuncionario(Funcionario funcionario) async {
    http.Response response =
        await http.put(BASE_URL + "Funcionario/" + funcionario.id,
            body: jsonEncode({
              "nome": funcionario.nome,
              "email": funcionario.email,
              "password": funcionario.password,
              "telefone": funcionario.telefone,
              "cpf": funcionario.cpf
            }),
            headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return new Funcionario.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  ///////////////////////////////////Cliente//////////////////////////////////////////////
  Future<List<Cliente>> getCliente() async {
    http.Response response = await http.get(BASE_URL + 'Cliente',
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Cliente> clientes = json.decode(response.body).map<Cliente>((map) {
        return Cliente.fromJson(map);
      }).toList();
      return clientes;
    } else {
      return null;
    }
  }

  Future<List<Cliente>> getClienteOne(String codigo) async {
    http.Response response = await http.get(BASE_URL + 'Cliente/' + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Cliente> clientes = json.decode(response.body).map<Cliente>((map) {
        return Cliente.fromJson(map);
      }).toList();
      return clientes;
    } else {
      return null;
    }
  }

  Future<bool> deletarCliente(String codigo) async {
    http.Response response = await http.delete(BASE_URL + "Cliente/" + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<Cliente> atualizarCliente(Cliente cliente) async {
    http.Response response = await http.put(BASE_URL + "Cliente/" + cliente.id,
        body: jsonEncode({
          "nome": cliente.nome,
          "email": cliente.email,
          "password": cliente.password,
          "telefone": cliente.telefone,
          "cpf": cliente.cpf
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return new Cliente.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

///////////////////////////////////Pedido//////////////////////////////////////////////
  Future<List<Cadastro_Pedido>> getPedido() async {
    http.Response response = await http.get(BASE_URL + 'Pedido',
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Cadastro_Pedido> pedidos =
          json.decode(response.body).map<Cadastro_Pedido>((map) {
        return Cadastro_Pedido.fromJson(map);
      }).toList();
      return pedidos;
    } else {
      return null;
    }
  }

  Future<Cadastro_Pedido> cadastrarNewPedido(
      Cliente cliente, Cadastro_Pedido pedido, int login_id) async {
    http.Response response = await http.post(BASE_URL + "Pedido/novo_pedido",
        body: jsonEncode({
          "nome": cliente.nome,
          "email": cliente.email,
          "password": cliente.password,
          "telefone": cliente.telefone,
          "cpf": cliente.cpf,
          "cd_tipo": pedido.cd_tipo,
          "cd_status": pedido.cd_status,
          "cd_funcionario": login_id,
          "marca": pedido.marca,
          "modelo": pedido.modelo,
          "defeito": pedido.defeito,
          "descricao": pedido.descricao
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Cadastro_Pedido dadosJson =
          new Cadastro_Pedido.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<Cadastro_Pedido> cadastrarPedido(
      Cadastro_Pedido pedido, int login_id) async {
    http.Response response = await http.post(BASE_URL + "Pedido",
        body: jsonEncode({
          "cd_cliente": pedido.cd_cliente,
          "cd_tipo": pedido.cd_tipo,
          "cd_status": pedido.cd_status,
          "cd_funcionario": login_id,
          "marca": pedido.marca,
          "modelo": pedido.modelo,
          "defeito": pedido.defeito,
          "descricao": pedido.descricao
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Cadastro_Pedido dadosJson =
          new Cadastro_Pedido.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<bool> deletarPedido(String codigo) async {
    http.Response response = await http.delete(BASE_URL + "Pedido/" + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Cadastro_Pedido> atualizarPedido(
      Cadastro_Pedido pedido, int login_id) async {
    http.Response response = await http.put(BASE_URL + "Pedido/" + pedido.id,
        body: jsonEncode({
          "cd_tipo": pedido.cd_tipo,
          "cd_status": pedido.cd_status,
          "cd_funcionario": login_id,
          "marca": pedido.marca,
          "modelo": pedido.modelo,
          "defeito": pedido.defeito,
          "descricao": pedido.descricao
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return new Cadastro_Pedido.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

/////////////////////////////////Client Pedido////////////////////////////////////////////////////
  Future<List<Cadastro_Pedido>> getClientPedido(String codigo) async {
    http.Response response = await http.get(BASE_URL + 'Clientpedido/' + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Cadastro_Pedido> pedidos =
          json.decode(response.body).map<Cadastro_Pedido>((map) {
        return Cadastro_Pedido.fromJson(map);
      }).toList();
      return pedidos;
    } else {
      return null;
    }
  }

///////////////////////////////////Item Pedido///////////////////////////////////////
  Future<List<Item_Pedido>> getItem(String codigo) async {
    http.Response response = await http.get(BASE_URL + 'Itempedido/' + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Item_Pedido> itens =
          json.decode(response.body).map<Item_Pedido>((map) {
        return Item_Pedido.fromJson(map);
      }).toList();
      return itens;
    } else {
      return null;
    }
  }

///////////////////////////////////Serviços//////////////////////////////////////////
  Future<Servicos> cadastrarServicos(Servicos servico, String id) async {
    http.Response response = await http.post(BASE_URL + "Servico/" + id,
        body:
            jsonEncode({"servico": servico.servico, "precos": servico.precos}),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Servicos dadosJson = new Servicos.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<bool> deletarServico(String codigo) async {
    http.Response response = await http.delete(BASE_URL + "Servico/" + codigo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Item_Pedido> atualizarServicos(Item_Pedido item) async {
    http.Response response = await http.put(
        BASE_URL + "Servico/" + item.cd_servicos,
        body: jsonEncode({"servico": item.Servico, "precos": item.Precos}),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return new Item_Pedido.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

///////////////////////////////////Tipo//////////////////////////////////////////////
  Future<Tipo> cadastrarTipo(Tipo tipo) async {
    http.Response response = await http.post(BASE_URL + "Tipo",
        body: jsonEncode({
          "type": tipo.type,
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Tipo dadosJson = new Tipo.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<List<Tipo>> getType() async {
    http.Response response = await http.get(BASE_URL + 'Tipo',
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Tipo> types = json.decode(response.body).map<Tipo>((map) {
        return Tipo.fromJson(map);
      }).toList();
      return types;
    } else {
      return null;
    }
  }

  Future<bool> deletarTipo(String codigoTipo) async {
    http.Response response = await http.delete(BASE_URL + "Tipo/" + codigoTipo,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Tipo> atualizarTipo(Tipo tipo) async {
    http.Response response = await http.put(BASE_URL + "Tipo/" + tipo.id,
        body: jsonEncode({
          "type": tipo.type,
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return new Tipo.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

///////////////////////////////////Status//////////////////////////////////////////////
  Future<Status> cadastrarStatus(Status status) async {
    http.Response response = await http.post(BASE_URL + "Status",
        body: jsonEncode({
          "status": status.status,
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Status dadosJson = new Status.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }

  Future<List<Status>> getStatus() async {
    http.Response response = await http.get(BASE_URL + 'Status',
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Status> statuss = json.decode(response.body).map<Status>((map) {
        return Status.fromJson(map);
      }).toList();
      return statuss;
    } else {
      return null;
    }
  }

  Future<bool> deletarStatus(String codigoStatus) async {
    http.Response response = await http.delete(
        BASE_URL + "Status/" + codigoStatus,
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Status> atualizarStatus(Status status) async {
    http.Response response = await http.put(BASE_URL + "Status/" + status.id,
        body: jsonEncode({"status": status.status}),
        headers: {'token': token, 'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      return new Status.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
