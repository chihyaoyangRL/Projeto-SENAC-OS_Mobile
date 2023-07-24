import 'package:flutter/material.dart';
import 'package:ordem_services/ui_admin/funcionario/cadastro.dart';
import 'package:ordem_services/ui_admin/funcionario/lista.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ordem_services/helper/Api.dart';

class TabBarFuncionario extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  TabBarFuncionario(this.login_id, this.nome, this.email, this.status, this.api,
      {Key key})
      : super(key: key);

  @override
  _TabBarFuncionarioState createState() => _TabBarFuncionarioState();
}

class _TabBarFuncionarioState extends State<TabBarFuncionario> {
  //目前選擇頁索引值 index(Página) atual
  int _currentIndex = 0; //預設值
  List<Widget> pages() => [
        ListaFuncionario(widget.api, widget.login_id, widget.nome, widget.email,
            widget.status),
        CadastroFuncionario(widget.nome, widget.email, widget.status),
      ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> page = pages();
    return Scaffold(
      body: page[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.list, size: 30),
          Icon(Icons.edit, size: 30),
        ],
        color: Colors.greenAccent,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
    );
  }
}
