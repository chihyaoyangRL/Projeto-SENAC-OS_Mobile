import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/status_helper.dart';
import 'package:ordem_services/ui_admin/status/alterar.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListaStatus extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  ListaStatus(this.api, this.login_id, this.nome, this.email, this.status);

  @override
  _ListaStatusState createState() => _ListaStatusState();
}

class _ListaStatusState extends State<ListaStatus> {
  List<Status> status = List();
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
        _getAllStatus();
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
          title: Text("Listar Status"),
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
                  itemCount: status.length,
                  itemBuilder: (context, index) {
                    return _statusCard(context, index);
                  }),
        ));
  }

  Widget _statusCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Status: ' + status[index].status,
                  overflow: TextOverflow.ellipsis),
              trailing: Text((index + 1).toString()),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _Alterar({Status status}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateStatus(status, widget.login_id)));
    if (recContact != null) {
      setState(() {
        isLoading = true;
      });
      if (status != null) {
        await widget.api.atualizarStatus(recContact);
      }
      _getAllStatus();
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
        _Alterar(status: status[index]);
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
                          if (await widget.api
                                  .deletarStatus(status[index].id) ==
                              true) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              status.removeAt(index);
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

  _getAllStatus() {
    widget.api.getStatus().then((list) {
      setState(() {
        status = list;
        isLoading = false;
      });
    });
  }
}
