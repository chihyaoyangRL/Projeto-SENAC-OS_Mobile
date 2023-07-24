import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/utils/Strings.dart';
import 'package:ordem_services/helper/Databases.dart';

class LoginHelper {
  static final LoginHelper _instance = LoginHelper.internal();

  factory LoginHelper() => _instance;

  LoginHelper.internal();

  Databases databases = new Databases();

  Future<bool> saveLogado(int login_id, String nome, String email,
      dynamic status, String tokens) async {
    Database dbLogado = await databases.db;
    Logado logado = new Logado();
    logado.id = 1;
    logado.logado_login_id = login_id;
    logado.nome = nome;
    logado.email = email;
    logado.status = status;
    logado.token = tokens;
    if (await dbLogado.insert(logadoTable, logado.toMap()) > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<Logado> getLogado() async {
    Database dbLogado = await databases.db;
    List<Map> maps = await dbLogado.rawQuery("SELECT * FROM $logadoTable");
    if (maps.length > 0) {
      Logado usuariologado = Logado.fromMap(maps.first);
      return usuariologado;
    } else {
      return null;
    }
  }

  Future<int> deleteLogado() async {
    Database dbLogin = await databases.db;
    await dbLogin.delete(logadoTable);
    return 1;
  }

  Future close() async {
    Database dbLogin = await databases.db;
    dbLogin.close();
  }
}

class Logado {
  int id;
  String nome;
  String email;
  dynamic logado_login_id;
  dynamic status;
  String token;

  Logado();

  Logado.fromMap(Map map) {
    id = map[idLogadoColumn];
    nome = map[nomeLogadoColumn];
    email = map[emailLogadoColumn];
    logado_login_id = map[login_idLogadoColumn];
    status = map[statusColumn];
    token = map[tokenColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idLoginColumn: id,
      nomeLogadoColumn: nome,
      emailLogadoColumn: email,
      login_idLogadoColumn: logado_login_id,
      statusColumn: status,
      tokenColumn: token
    };
    return map;
  }
}

class Login {
  int id;
  String nome;
  String email;
  String password;
  String telefone;
  String cpf;
  dynamic status;
  String token;

  Login();

  Login.fromMap(Map map) {
    id = int.parse(map[idLoginColumn]);
    email = map[emailLoginColumn];
    nome = map[nomeLoginColumn];
    password = map[passwordLoginColumn];
    telefone = map[telefoneLoginColumn];
    cpf = map[cpfLoginColumn];
    status = map[statusLoginColumn];
    token = map[tokenLoginColumn];
  }

  @override
  String toString() {
    return "Login(id: $id, nome: $nome, email: $email, password: $password,telefone: $telefone,cpf: $cpf,status:$status, token: $token)";
  }
}
