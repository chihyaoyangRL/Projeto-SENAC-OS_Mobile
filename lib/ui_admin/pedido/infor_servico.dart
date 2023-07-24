import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/item_pedido_helper.dart';
import 'package:ordem_services/ui_admin/pedido/updateservico.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Information_Servico extends StatefulWidget {
  final Api api;
  final dynamic id;
  final dynamic Cliente;

  Information_Servico(
    this.api,
    this.id,
    this.Cliente,
  );

  @override
  _Information_ServicoState createState() => _Information_ServicoState();
}

class _Information_ServicoState extends State<Information_Servico> {
  List<Item_Pedido> item = List();
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
        _getItem();
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
                    color: Colors.red,
                  ),
                )),
          )
        : new Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Cliente),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: WillPopScope(
        child: (isLoading)
            ? new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              )
            : ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return _itemCard(context, index);
                }),
      ),
    );
  }

  void _showContactPage({Item_Pedido item}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlterarServico(item, widget.api)));
    if (recContact != null) {
      setState(() {
        isLoading = true;
      });
      if (item != null) {
        await widget.api.atualizarServicos(recContact);
      }
      _getItem();
    }
  }

  Widget _itemCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
          margin: new EdgeInsets.only(
              left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          child: ListTile(
            title: Text('Serviço feitos: ' + item[index].Servico,
                style: TextStyle(color: Colors.deepOrangeAccent)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('Valor: ' + item[index].Precos,
                      style: TextStyle(color: Colors.indigoAccent)),
                ),
                Divider(),
                ButtonTheme.bar(
                  child: new ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        color: Colors.blue,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          _showContactPage(item: item[index]);
                        },
                      ),
                      FlatButton(
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                        color: Colors.deepPurple,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        textColor: Colors.white,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Aviso !'),
                                  content:
                                      Text('Você realmente deseja excluir ?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Sim'),
                                      onPressed: () {
                                        connect.check().then((intenet) async {
                                          if (intenet != null && intenet) {
                                            print("connect");
                                            dialog.msg(context, 'Aviso',
                                                'Aguarde ...');
                                            if (await widget.api.deletarServico(
                                                    item[index].cd_servicos) ==
                                                true) {
                                              setState(() {
                                                Navigator.pop(context);
                                                item.removeAt(index);
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              Navigator.pop(context);
                                              dialog.showAlertDialog(context,
                                                  'Aviso', 'Falha ao deletar');
                                            }
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            print("no connect");
                                            dialog.showAlertDialog(
                                                context,
                                                'Aviso',
                                                'Please check your connection and try again !');
                                          }
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _getItem() async {
    await widget.api.getItem(widget.id).then((list) {
      setState(() {
        item = list;
        isLoading = false;
      });
    });
  }
}
