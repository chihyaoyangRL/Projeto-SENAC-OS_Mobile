import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/funcionario_helper.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/tabbar_funcionario.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:validators/validators.dart';

class Dados_usuario extends StatefulWidget {
  int login_id;
  final Api api;

  Dados_usuario(this.login_id, this.api);

  @override
  _Dados_usuarioState createState() => _Dados_usuarioState();
}

class _Dados_usuarioState extends State<Dados_usuario> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  Funcionario _editedFuncionario;
  List<Funcionario> funcionario = List();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  LoginHelper helper = LoginHelper();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _getFuncionarios();
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
        title: Text("Dados de Funcionário"),
        centerTitle: true,
      ),
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
                  return _clienteCard(context, index);
                }),
      ),
    );
  }

  Widget _clienteCard(BuildContext context, int index) {
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
              leading: Icon(Icons.account_circle),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    _editedFuncionario = Funcionario.fromJson(funcionario[index].toJson());
    _nomeController.text = _editedFuncionario.nome;
    _emailController.text = _editedFuncionario.email;
    _telefoneController.text = _editedFuncionario.telefone;
    _cpfController.text = _editedFuncionario.cpf;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Scaffold(
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
                            _editedFuncionario.nome = text;
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
                          style: TextStyle(color: Colors.white),
                          obscureText: false,
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
                          ),
                          onChanged: (text) {
                            _editedFuncionario.password = text;
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
                            _editedFuncionario.telefone = text;
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
                            if (isNumeric(_telefoneController.text)) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              connect.check().then((intenet) async {
                                if (intenet != null && intenet) {
                                  print("connect");
                                  Navigator.pop(context);
                                  await widget.api
                                      .atualizarFuncionario(_editedFuncionario);
                                  Logado logado = await helper.getLogado();
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => TabBarFuncionario(
                                            logado.logado_login_id,
                                            logado.nome,
                                            logado.email,
                                            logado.status,
                                            Api(token: logado.token))),
                                  );
                                } else {
                                  print("no connect");
                                  dialog.showAlertDialog(context, 'Aviso',
                                      'Please check your connection and try again !');
                                }
                              });
                            }
                          }
                        },
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  _getFuncionarios() async {
    connect.check().then((intenet) async {
      if (intenet != null && intenet) {
        print("connect");
        await widget.api
            .getfuncionarioOne(widget.login_id.toString())
            .then((list) {
          setState(() {
            funcionario = list;
            isLoading = false;
          });
        });
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
