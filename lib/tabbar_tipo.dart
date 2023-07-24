import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/ui_admin/tipo/cadastro.dart';
import 'package:ordem_services/ui_admin/tipo/lista.dart';

class TabBarTipo extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  TabBarTipo(this.login_id, this.nome, this.email, this.status, this.api,
      {Key key})
      : super(key: key);

  @override
  _TabBarTipoState createState() => _TabBarTipoState();
}

class _TabBarTipoState extends State<TabBarTipo> {
  //目前選擇頁索引值 index(Página) atual
  int _currentIndex = 0; //預設值
  List<Widget> pages() => [
        ListaTipo(widget.api, widget.login_id, widget.nome, widget.email,
            widget.status),
        CadastroTipo(widget.nome, widget.email, widget.status),
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
        color: Colors.indigo,
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
