import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ordem_services/helper/cliente_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/validator.dart';
import 'package:validators/validators.dart';

class UpdateCliente extends StatefulWidget {
  final Cliente client;
  final login_id;

  UpdateCliente(this.client, this.login_id);

  @override
  _UpdateClienteState createState() => _UpdateClienteState();
}

class _UpdateClienteState extends State<UpdateCliente> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = MaskedTextController(mask: '000.000.000-00');

  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  Cliente _editedCliente;
  bool passwordVisible;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    _editedCliente = Cliente.fromJson(widget.client.toJson());
    _nomeController.text = _editedCliente.nome;
    _emailController.text = _editedCliente.email;
    _telefoneController.text = _editedCliente.telefone;
    _cpfController.text = _editedCliente.cpf;
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Alterar Cliente'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(60),
                      ],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.45),
                        hintText: " Nome",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedCliente.nome = text;
                      },
                      controller: _nomeController,
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
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.45),
                        hintText: " E-mail",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedCliente.email = text;
                      },
                      controller: _emailController,
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
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.45),
                        hintText: " Digite a Senha",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                        suffixIcon: Container(
                          child: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedCliente.password = text;
                      },
                      controller: _passwordController,
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
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(20),
                      ],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.45),
                        hintText: " Telefone",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedCliente.telefone = text;
                      },
                      controller: _telefoneController,
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
                      maxLength: 14,
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
                        hintText: " CPF",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.assignment_ind,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedCliente.cpf = text;
                      },
                      controller: _cpfController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo obrigatório !";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(color: Colors.blueGrey)),
                    ],
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.transparent)),
                    child: Text("Alterar"),
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        if (isEmail(_emailController.text)) {
                          if (isNumeric(_telefoneController.text)) {
                            if (CPFValidator.isValid(_cpfController.text)) {
                              connect.check().then((intenet) {
                                if (intenet != null && intenet) {
                                  print("connect");
                                  Navigator.pop(context, _editedCliente);
                                } else {
                                  print("no connect");
                                  dialog.showAlertDialog(context, 'Aviso',
                                      'Please check your connection and try again !');
                                }
                              });
                            } else {
                              dialog.showAlertDialog(
                                  context, 'Aviso', 'Preencher com CPF válido');
                            }
                          } else {
                            dialog.showAlertDialog(
                                context, 'Aviso', 'Preencher somente número');
                          }
                        } else {
                          dialog.showAlertDialog(
                              context, 'Aviso', 'Preencher com E-mail válido');
                        }
                      }
                    },
                  ),
                ],
              )),
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
