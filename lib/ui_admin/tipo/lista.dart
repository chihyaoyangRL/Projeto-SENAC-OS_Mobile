import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/tipo_helper.dart';
import 'package:ordem_services/ui_admin/tipo/alterar.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListaTipo extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  ListaTipo(this.api, this.login_id, this.nome, this.email, this.status);

  @override
  _ListaTipoState createState() => _ListaTipoState();
}

class _ListaTipoState extends State<ListaTipo> {
  List<Tipo> tipo = List();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    connect.check().then((intenet) {
      if (intenet != null && intenet) {
        print("connect");
        _getAllTipo();
      } else {
        setState(() {
          isLoading = false;
        });
        print("no connect");
        dialog.showAlertDialog(
            context, 'Aviso', 'Please check your connection and try again !');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = isLoading
        ? new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(
                  child: SpinKitDualRing(
                    color: Colors.blue,
                  ),
                )),
          )
        : new Container();
    return Scaffold(
        appBar: AppBar(
          title: Text("Listar Tipo"),
          centerTitle: true,
        ),
        drawer: DrawerMenu(widget.nome, widget.email, widget.status),
        body: WillPopScope(
          child: (isLoading)
              ? new Align(
                  child: loadingIndicator,
                  alignment: FractionalOffset.center,
                )
              : ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: tipo.length,
                  itemBuilder: (context, index) {
                    return _tipoCard(context, index);
                  }),
        ));
  }

  Widget _tipoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('type: ' + tipo[index].type,
                  overflow: TextOverflow.ellipsis),
              trailing: Text((index + 1).toString()),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _Alterar({Tipo tipo}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateTipo(tipo, widget.login_id)));
    if (recContact != null) {
      setState(() {
        isLoading = true;
      });
      if (tipo != null) {
        await widget.api.atualizarTipo(recContact);
      }
      _getAllTipo();
    }
  }

  void _showOptions(BuildContext context, int index) {
    List<Widget> botoes = [];
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.edit, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Alterar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
        _Alterar(tipo: tipo[index]);
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.delete, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Deletar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Aviso !'),
                content: Text('Você realmente deseja excluir ?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Sim'),
                    onPressed: () {
                      connect.check().then((intenet) async {
                        if (intenet != null && intenet) {
                          print("connect");
                          dialog.msg(context, 'Aviso', 'Aguarde ...');
                          if (await widget.api.deletarTipo(tipo[index].id) ==
                              true) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              tipo.removeAt(index);
                              Navigator.pop(context);
                            });
                          } else {
                            Navigator.pop(context);
                            dialog.showAlertDialog(
                                context, 'Aviso', 'Falha ao deletar');
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          print("no connect");
                          dialog.showAlertDialog(context, 'Aviso',
                              'Please check your connection and try again !');
                        }
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      },
    ));
    dialog.showBottomOptions(context, botoes);
  }

  _getAllTipo() async {
    widget.api.getType().then((list) {
      setState(() {
        tipo = list;
        isLoading = false;
      });
    });
  }
}
