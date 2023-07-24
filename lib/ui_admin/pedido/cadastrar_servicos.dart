import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/servicos_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CadastrarServicos extends StatefulWidget {
  final dynamic id;
  final Api api;
  int login_id;

  CadastrarServicos(this.id, this.api, this.login_id);

  @override
  _CadastrarServicosState createState() => _CadastrarServicosState();
}

class _CadastrarServicosState extends State<CadastrarServicos> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _servicesController = TextEditingController();
  final _precosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  bool _userEdited = false;
  bool isLoading = false;
  Servicos servico;
  Servicos _editedservico;

  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();

  @override
  void initState() {
    super.initState();
    if (servico == null) {
      _editedservico = Servicos();
    }
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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Cadastrar Serviços'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Serviço feitos",
                    style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(color: Colors.blueGrey)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    maxLines: 5,
                    maxLength: 200,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey.withOpacity(0.45),
                      hintText: " Descrição dos Servicos",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.room_service,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedservico.servico = text;
                    },
                    controller: _servicesController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório !";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey.withOpacity(0.45),
                      hintText: " Preço",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                        color: Colors.blue,
                      ),
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                    },
                    controller: _precosController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório !";
                      } else {
                        setState(() {
                          _editedservico.precos = value;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: (isLoading)
                      ? new Align(
                          child: loadingIndicator,
                          alignment: FractionalOffset.center,
                        )
                      : RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.transparent)),
                          child: Text("Cadastrar Serviço"),
                          color: Colors.blueGrey,
                          textColor: Colors.white,
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            if (_formkey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              connect.check().then((intenet) async {
                                if (intenet != null && intenet) {
                                  print("connect");
                                  if (await widget.api.cadastrarServicos(
                                          _editedservico, widget.id) !=
                                      null) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    dialog.showAlertDialog(context, 'Aviso',
                                        'Falhao ao cadastrar serviço');
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
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text('Se sair as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
