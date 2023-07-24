import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/tabbar.dart';
import 'package:ordem_services/tabbar_funcionario.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/tabbar_login.dart';
import 'package:ordem_services/tabbar_status.dart';
import 'package:ordem_services/tabbar_tipo.dart';
import 'package:ordem_services/ui_admin/cliente/lista.dart';
import 'package:ordem_services/ui_admin/dados_user.dart';
import 'package:ordem_services/ui_cliente/data_user.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMenu extends StatefulWidget {
  String nome;
  String email;
  dynamic status;

  DrawerMenu(this.nome, this.email, this.status);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  LoginHelper helperLog = LoginHelper();
  var phone = 4999579414;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(widget.nome),
            accountEmail: Text(widget.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/user.png'),
            ),
          ),
          (widget.status == "1" || widget.status == 1)
              ? ListTile(
                  title: Text('Home'),
                  leading: Icon(
                    Icons.home,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarMenu(
                                logado.logado_login_id,
                                logado.nome,
                                logado.email,
                                logado.status,
                                Api(token: logado.token))));
                  },
                )
              : Visibility(
                  visible: true,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
          (widget.status == "1" || widget.status == 1)
              ? ListTile(
                  title: Text('Lista de Cliente'),
                  leading: Icon(
                    Icons.supervisor_account,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListaCliente(
                                Api(token: logado.token),
                                logado.logado_login_id,
                                logado.nome,
                                logado.email,
                                logado.status)));
                  },
                )
              : Visibility(
                  visible: true,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
          (widget.status == "1" || widget.status == 1)
              ? ListTile(
                  title: Text('Cadastrar de Funcionários'),
                  leading: Icon(
                    Icons.supervisor_account,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarFuncionario(
                                logado.logado_login_id,
                                logado.nome,
                                logado.email,
                                logado.status,
                                Api(token: logado.token))));
                  },
                )
              : Visibility(
                  visible: true,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
          (widget.status == "1" || widget.status == 1)
              ? ListTile(
                  title: Text('Cadastrar Tipo de Produto'),
                  leading: Icon(
                    Icons.style,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarTipo(
                                logado.logado_login_id,
                                logado.nome,
                                logado.email,
                                logado.status,
                                Api(token: logado.token))));
                  },
                )
              : Visibility(
                  visible: true,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
          (widget.status == "1" || widget.status == 1)
              ? ListTile(
                  title: Text('Cadastrar Status do pedido'),
                  leading: Icon(
                    Icons.assistant,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarStatus(
                                logado.logado_login_id,
                                logado.nome,
                                logado.email,
                                logado.status,
                                Api(token: logado.token))));
                  },
                )
              : Visibility(
                  visible: true,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
          (widget.status == "2" || widget.status == 2)
              ? ListTile(
                  title: Text('Contato Suporte'),
                  leading: Icon(
                    Icons.comment,
                  ),
                  onTap: () {
                    launch("whatsapp://send?text=Olá"
                        "&phone=+55$phone");
                    Navigator.pop(context);
                  },
                )
              : Visibility(
                  visible: true,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
          (widget.status == "2" || widget.status == 2)
              ? ListTile(
                  title: Text('Dados do Usuário'),
                  leading: Icon(
                    Icons.verified_user,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                Dados_User(logado.logado_login_id, Api())));
                  },
                )
              : ListTile(
                  title: Text('Dados do Usuário'),
                  leading: Icon(
                    Icons.verified_user,
                  ),
                  onTap: () async {
                    Logado logado = await helperLog.getLogado();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                Dados_usuario(logado.logado_login_id, Api())));
                  },
                ),
          Divider(),
          ListTile(
            title: Text('Sair'),
            leading: Icon(
              Icons.exit_to_app,
            ),
            onTap: () async {
              await helperLog.deleteLogado();
              Navigator.pop(context);
              await Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TabBarLogin()));
            },
          ),
        ],
      ),
    );
  }
}
