import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/item_pedido_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';

class AlterarServico extends StatefulWidget {
  final Item_Pedido itens;
  final Api api;

  AlterarServico(this.itens, this.api);

  @override
  _AlterarServicoState createState() => _AlterarServicoState();
}

class _AlterarServicoState extends State<AlterarServico> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _servicesController = TextEditingController();
  final _precosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  bool _userEdited = false;
  Item_Pedido _editeditens;
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();

  @override
  void initState() {
    super.initState();
    _editeditens = Item_Pedido.fromJson(widget.itens.toJson());
    _servicesController.text = _editeditens.Servico;
    _precosController.text = _editeditens.Precos;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Alterar Serviços'),
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
                      _editeditens.Servico = text;
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
                          _editeditens.Precos = value;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.transparent)),
                    child: Text("Alterar"),
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (_formkey.currentState.validate()) {
                        connect.check().then((intenet) {
                          if (intenet != null && intenet) {
                            print("connect");
                            Navigator.pop(context, _editeditens);
                          } else {
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
