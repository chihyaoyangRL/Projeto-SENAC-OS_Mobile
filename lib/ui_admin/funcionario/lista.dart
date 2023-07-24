import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/funcionario_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ordem_services/ui_admin/funcionario/alterar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListaFuncionario extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  ListaFuncionario(this.api, this.login_id, this.nome, this.email, this.status);

  @override
  _ListaFuncionarioState createState() => _ListaFuncionarioState();
}

class _ListaFuncionarioState extends State<ListaFuncionario> {
  List<Funcionario> funcionario = List();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  bool isLoading = false;

  //Filtro Search
  final _key = new GlobalKey<ScaffoldState>();
  Widget appBarTitle = new Text("Lista de Funcionários");
  Icon actionIcon = new Icon(Icons.search);
  final _search = TextEditingController();
  List<Funcionario> _queryResults = [];
  List<Funcionario> _filter = [];
  var phone;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    connect.check().then((intenet) {
      if (intenet != null && intenet) {
        print("connect");
        _getAllFuncionarios();
      } else {
        setState(() {
          isLoading = false;
        });
        print("no connect");
        dialog.showAlertDialog(
            context, 'Aviso', 'Please check your connection and try again !');
      }
    });
    print(widget.login_id);
    print("dlkasldklaskdasçkdlçask");
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
                    this.appBarTitle = new Text("Lista de Funcionários");
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
                  itemCount: funcionario.length,
                  itemBuilder: (context, index) {
                    return _funcionarioCard(context, index);
                  }),
        ));
  }

  Widget _funcionarioCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Nome: ' + funcionario[index].nome,
                  overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('E-mail: ' + funcionario[index].email,
                      overflow: TextOverflow.ellipsis),
                  Text('Telefone: ' + funcionario[index].telefone,
                      overflow: TextOverflow.ellipsis),
                  Text('CPF: ' + funcionario[index].cpf,
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

  void _Alterar({Funcionario funcionario}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UpdateFunconario(funcionario, widget.login_id)));
    if (recContact != null) {
      setState(() {
        isLoading = true;
      });
      if (funcionario != null) {
        await widget.api.atualizarFuncionario(recContact);
      }
      _getAllFuncionarios();
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
        phone = funcionario[index].telefone;
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
        launch(
            "mailto:${funcionario[index].email}?subject=Olá&body=Tudo bem ?");
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
        _Alterar(funcionario: funcionario[index]);
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
                                  .deletarFuncionario(funcionario[index].id) ==
                              true) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              funcionario.removeAt(index);
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

  _getAllFuncionarios() async {
    widget.api.getfuncionario().then((list) {
      setState(() {
        funcionario = list;
        debugPrint(funcionario.toString());
        _filter = list;
        funcionario = funcionario
            .where((func) =>
                !func.id.toString().contains(widget.login_id.toString()))
            .toList();
        isLoading = false;
      });
    });
  }

  //Filtro Seach
  _ListaFuncionarioState() {
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
      funcionario = _queryResults;
    });
  }
}
