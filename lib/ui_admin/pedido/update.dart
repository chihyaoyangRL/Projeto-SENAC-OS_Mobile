import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/cadastro_pedido_helper.dart';
import 'package:ordem_services/helper/status_helper.dart';
import 'package:ordem_services/helper/tipo_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AlterarPedido extends StatefulWidget {
  final Cadastro_Pedido pedidos;
  final Api api;
  final login_id;

  AlterarPedido(this.pedidos, this.api, this.login_id);

  @override
  _AlterarPedidoState createState() => _AlterarPedidoState();
}

class _AlterarPedidoState extends State<AlterarPedido> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _defeitoController = TextEditingController();
  final _descricaoController = TextEditingController();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  Cadastro_Pedido _editedpedido;
  bool isLoading = false;
  bool _userEdited = false;

  //DropDown
  String _dropdownError;
  List<Tipo> type = List();
  String _selectedtype;
  List<Status> status = List();
  String _selectedStatus;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    connect.check().then((intenet) {
      if (intenet != null && intenet) {
        print("connect");
        _getAllType();
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

    _editedpedido = Cadastro_Pedido.fromJson(widget.pedidos.toJson());
    _marcaController.text = _editedpedido.marca;
    _modeloController.text = _editedpedido.modelo;
    _defeitoController.text = _editedpedido.defeito;
    _descricaoController.text = _editedpedido.descricao;
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = isLoading
        ? new Container(
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(
                  child: SpinKitThreeBounce(
                    size: 30,
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
          title: Text('Update Pedido'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(color: Colors.blueGrey)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Dados do Pedido",
                    style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(color: Colors.blueGrey)),
                  child: (isLoading)
                      ? new Align(
                          child: loadingIndicator,
                          alignment: FractionalOffset.center,
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text(
                              'Seleciona uma tipo',
                            ),
                            items: type?.map((item) {
                                  return new DropdownMenuItem(
                                    child: Text(item.type.toString()),
                                    value: item.id.toString(),
                                  );
                                }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                _userEdited = true;
                                _selectedtype = value;
                                _editedpedido.cd_tipo = _selectedtype;
                                _dropdownError = null;
                              });
                            },
                            value: _editedpedido.cd_tipo,
                          ),
                        ),
                ),
                _dropdownError == null
                    ? SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          _dropdownError ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(color: Colors.blueGrey)),
                  child: (isLoading)
                      ? new Align(
                          child: loadingIndicator,
                          alignment: FractionalOffset.center,
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text(
                              'Selecione status do pedido',
                            ),
                            items: status?.map((item) {
                                  return new DropdownMenuItem(
                                    child: Text(item.status.toString()),
                                    value: item.id.toString(),
                                  );
                                }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                _userEdited = true;
                                _selectedStatus = value;
                                _editedpedido.cd_status = _selectedStatus;
                                _dropdownError = null;
                              });
                            },
                            value: _editedpedido.cd_status,
                          ),
                        ),
                ),
                _dropdownError == null
                    ? SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          _dropdownError ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey.withOpacity(0.45),
                      hintText: " Marca",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.collections_bookmark,
                          color: Colors.white,
                        ),
                        color: Colors.blue,
                      ),
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedpedido.marca = text;
                    },
                    controller: _marcaController,
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey.withOpacity(0.45),
                      hintText: " Modelo",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.mobile_screen_share,
                          color: Colors.white,
                        ),
                        color: Colors.blue,
                      ),
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedpedido.modelo = text;
                    },
                    controller: _modeloController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório !";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      hintText: " Defeito",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.report_problem,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedpedido.defeito = text;
                    },
                    controller: _defeitoController,
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
                      hintText: " Descrição",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.text_fields,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedpedido.descricao = text;
                    },
                    controller: _descricaoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório !";
                      }
                      return null;
                    },
                  ),
                ),
                (isLoading)
                    ? new Align(
                        child: loadingIndicator,
                        alignment: FractionalOffset.center,
                      )
                    : Container(
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
                            if (_formkey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _validateForm();
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

  _validateForm() async {
    bool _isValid = _formkey.currentState.validate();
    if (_editedpedido == null) {
      setState(() => _dropdownError = "Campo obrigatório !");
      _isValid = false;
    }
    if (_isValid) {
      connect.check().then((intenet) {
        if (intenet != null && intenet) {
          print("connect");
          Navigator.pop(context, _editedpedido);
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
  }

  _getAllType() async {
    await widget.api.getType().then((list) {
      setState(() {
        type = list;
        isLoading = false;
      });
    });
  }

  _getAllStatus() async {
    await widget.api.getStatus().then((list) {
      setState(() {
        status = list;
        isLoading = false;
      });
    });
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
