import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/funcionario_helper.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:ordem_services/utils/validator.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:validators/validators.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:ordem_services/tabbar_funcionario.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CadastroFuncionario extends StatefulWidget {
  String nome;
  String email;
  dynamic status;

  CadastroFuncionario(this.nome, this.email, this.status);

  @override
  _CadastroFuncionarioState createState() => _CadastroFuncionarioState();
}

class _CadastroFuncionarioState extends State<CadastroFuncionario> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  LoginHelper helper = LoginHelper();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  Api api = new Api();
  Funcionario funcionario;
  Funcionario _editedFuncionario;
  bool isLoading = false;

//Enviar msg pelo whatsapp
  var email;
  var telefone;
  var password;

  @override
  void initState() {
    super.initState();
    if (funcionario == null) {
      _editedFuncionario = Funcionario();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Funcionários'),
        centerTitle: true,
      ),
      drawer: DrawerMenu(widget.nome, widget.email, widget.status),
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
                      email = text;
                      _editedFuncionario.email = text;
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
                      telefone = text;
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
                      _editedFuncionario.cpf = text;
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
                (isLoading)
                    ? new Align(
                        child: loadingIndicator,
                        alignment: FractionalOffset.center,
                      )
                    : RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.transparent)),
                        child: Text("Cadastrar"),
                        color: Colors.blueGrey,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            if (isEmail(_emailController.text)) {
                              if (isNumeric(_telefoneController.text)) {
                                if (CPFValidator.isValid(_cpfController.text)) {
                                  connect.check().then((intenet) async {
                                    if (intenet != null && intenet) {
                                      print("connect");
                                      _editedFuncionario.password =
                                          randomAlphaNumeric(8);
                                      password = _editedFuncionario.password;
                                      //cadastro
                                      if (await api.cadastrarFuncionario(
                                              _editedFuncionario) !=
                                          null) {
                                        //Enviar password pelo whatsapp
                                        launch(
                                            "whatsapp://send?text=Olá, aqui é o OS, baixe nosso aplicativo e faça login com seguintes dados: \n"
                                            "Email: $email\n"
                                            "Senha: $password\n"
                                            "Ou Faça login pelo telefone\n"
                                            "Acessa nosso Site/APP\n"
                                            "Site: https://ordemservices.000webhostapp.com/\n"
                                            "APP: https://play.google.com/store/apps/details?id=com.chihyaoyang.api_contatos\n"
                                            "&phone=+55$telefone");
                                        Logado logado =
                                            await helper.getLogado();
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TabBarFuncionario(
                                                        logado.logado_login_id,
                                                        logado.nome,
                                                        logado.email,
                                                        logado.status,
                                                        Api(
                                                            token: logado
                                                                .token))));
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        dialog.showAlertDialog(context, 'Aviso',
                                            'Funcionário não cadastrado verifica se o email já está cadastrado');
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
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  dialog.showAlertDialog(context, 'Aviso',
                                      'Preencher com CPF válido');
                                }
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                dialog.showAlertDialog(context, 'Aviso',
                                    'Preencher somente número');
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              dialog.showAlertDialog(context, 'Aviso',
                                  'Preencher com E-mail válido');
                            }
                          }
                        },
                      ),
              ],
            )),
      ),
    );
  }
}
