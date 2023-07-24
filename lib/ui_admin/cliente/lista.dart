import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/cliente_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ordem_services/ui_admin/cliente/alterar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListaCliente extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  ListaCliente(this.api, this.login_id, this.nome, this.email, this.status);

  @override
  _ListaClienteState createState() => _ListaClienteState();
}

class _ListaClienteState extends State<ListaCliente> {
  List<Cliente> cliente = List();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  bool isLoading = false;

  //Filtro Search
  final _key = new GlobalKey<ScaffoldState>();
  Widget appBarTitle = new Text("Lista de Cliente");
  Icon actionIcon = new Icon(Icons.search);
  final _search = TextEditingController();
  List<Cliente> _queryResults = [];
  List<Cliente> _filter = [];

  var phone;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    connect.check().then((intenet) {
      if (intenet != null && intenet) {
        print("connect");
        _getAllClientes();
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
        key: _key,
        appBar: AppBar(
          title: appBarTitle,
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      controller: _search,
                      decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search Name...",
                        hintStyle: new TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    _search.text = "";
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Lista de Cliente");
                  }
                });
              },
            ),
          ],
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
                  itemCount: cliente.length,
                  itemBuilder: (context, index) {
                    return _clienteCard(context, index);
                  }),
        ));
  }

  Widget _clienteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Nome: ' + cliente[index].nome,
                  overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('E-mail: ' + cliente[index].email,
                      overflow: TextOverflow.ellipsis),
                  Text('Telefone: ' + cliente[index].telefone,
                      overflow: TextOverflow.ellipsis),
                  Text('CPF: ' + cliente[index].cpf,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
              trailing: Text((index + 1).toString()),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _Alterar({Cliente cliente}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateCliente(cliente, widget.login_id)));
    if (recContact != null) {
      setState(() {
        isLoading = true;
      });
      if (cliente != null) {
        await widget.api.atualizarCliente(recContact);
      }
      _getAllClientes();
    }
  }

  void _showOptions(BuildContext context, int index) {
    List<Widget> botoes = [];
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.phone_in_talk, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Contato',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        phone = cliente[index].telefone;
        launch("whatsapp://send?text=Olá"
            "&phone=+55$phone");
        Navigator.pop(context);
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.email, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Enviar e-mail',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        launch("mailto:${cliente[index].email}?subject=Olá&body=Tudo bem ?");
        Navigator.pop(context);
      },
    ));
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
        _Alterar(cliente: cliente[index]);
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
                                  .deletarCliente(cliente[index].id) ==
                              true) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              cliente.removeAt(index);
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

  _getAllClientes() async {
    widget.api.getCliente().then((list) {
      setState(() {
        cliente = list;
        _filter = list;
        isLoading = false;
      });
    });
  }

  //Filtro Seach
  _ListaClienteState() {
    _search.addListener(() {
      if (_search.text.isEmpty) {
        setState(() {
          _queryResults = _filter;
        });
      } else {
        setState(() {
          _queryResults = _filter
              .where((name) =>
                  name.nome.toLowerCase().contains(_search.text.toLowerCase()))
              .toList();
        });
      }
      cliente = _queryResults;
    });
  }
}
