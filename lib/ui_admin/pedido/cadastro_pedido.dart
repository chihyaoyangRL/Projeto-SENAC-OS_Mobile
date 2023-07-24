import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/cadastro_pedido_helper.dart';
import 'package:ordem_services/helper/cliente_helper.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/helper/status_helper.dart';
import 'package:ordem_services/helper/tipo_helper.dart';
import 'package:ordem_services/tabbar.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CadasrarPedido extends StatefulWidget {
  final Api api;
  int login_id;

  CadasrarPedido(this.api, this.login_id);

  @override
  _CadasrarPedidoState createState() => _CadasrarPedidoState();
}

class _CadasrarPedidoState extends State<CadasrarPedido> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _defeitoController = TextEditingController();
  final _descricaoController = TextEditingController();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  LoginHelper helper = LoginHelper();
  Cadastro_Pedido pedido;
  Cadastro_Pedido _editedpedido;
  bool isLoading = false;
  bool _userEdited = false;

  //DropDown
  List<Cliente> client = List();
  String _selectedClient;
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
    if (pedido == null) {
      _editedpedido = Cadastro_Pedido();
    }
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
          title: Text('Cadasrar Pedido'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  autovalidate: false,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "Cliente",
                          style:
                              TextStyle(fontSize: 20, color: Colors.blueGrey),
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
                            : FormBuilderDropdown(
                                attribute: _selectedClient,
                                hint: Text('Seleciona o Cliente'),
                                validators: [FormBuilderValidators.required()],
                                items: client?.map((item) {
                                      return new DropdownMenuItem(
                                        child: Text(item.nome.toString()),
                                        value: item.id.toString(),
                                      );
                                    }).toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    _userEdited = true;
                                    _selectedClient = value;
                                    _editedpedido.cd_cliente = _selectedClient;
                                  });
                                },
                              ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Divider(color: Colors.blueGrey)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "Dados do Pedido",
                          style:
                              TextStyle(fontSize: 20, color: Colors.blueGrey),
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
                            : FormBuilderDropdown(
                                attribute: _selectedtype,
                                hint: Text('Seleciona uma tipo'),
                                validators: [FormBuilderValidators.required()],
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
                                  });
                                },
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
                            : FormBuilderDropdown(
                                attribute: _selectedStatus,
                                hint: Text('Selecione status do pedido'),
                                validators: [FormBuilderValidators.required()],
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
                                  });
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
                    ],
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
                          child: Text("Cadastrar"),
                          color: Colors.blueGrey,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formkey.currentState.validate() &&
                                _fbKey.currentState.saveAndValidate()) {
                              setState(() {
                                isLoading = true;
                              });
                              connect.check().then((intenet) async {
                                if (intenet != null && intenet) {
                                  print("connect");
                                  if (await widget.api.cadastrarPedido(
                                          _editedpedido, widget.login_id) !=
                                      null) {
                                    Logado logado = await helper.getLogado();
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TabBarMenu(
                                                logado.logado_login_id,
                                                logado.nome,
                                                logado.email,
                                                logado.status,
                                                Api(token: logado.token))));
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    dialog.showAlertDialog(context, 'Aviso',
                                        'Falhao ao cadastrar pedidos');
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

  _getAllClientes() async {
    await widget.api.getCliente().then((list) {
      setState(() {
        client = list;
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
