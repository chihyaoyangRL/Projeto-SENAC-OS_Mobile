import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/tabbar.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/ui_cliente/home_cliente.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  final Login login;
  final Api api;

  LoginPage({this.login, this.api});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool passwordVisible;
  bool isLoading = false;

  LoginHelper helper = LoginHelper();
  Api api = new Api();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.red.withOpacity(0.25),
                    hintText: " Digite seu email",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Container(
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      color: Colors.redAccent,
                    ),
                  ),
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
                    fillColor: Colors.red.withOpacity(0.25),
                    hintText: " Digite a Senha",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Container(
                      child: Icon(
                        Icons.vpn_key,
                        color: Colors.white,
                      ),
                      color: Colors.redAccent,
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
                  controller: _senhaController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Campo obrigatório !";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (isLoading)
                      ? new Align(
                          child: loadingIndicator,
                          alignment: FractionalOffset.center,
                        )
                      : RaisedButton(
                          padding: EdgeInsets.all(10),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.transparent)),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.red,
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
                                  Login user = await api.login(
                                      _emailController.text,
                                      _senhaController.text);
                                  if (user != null) {
                                    helper.saveLogado(user.id, user.nome,
                                        user.email, user.status, user.token);
                                    Logado logado = await helper.getLogado();
                                    if (logado.status == 1) {
                                      Navigator.pop(context);
                                      await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TabBarMenu(
                                                  user.id,
                                                  user.nome,
                                                  user.email,
                                                  user.status,
                                                  Api(token: user.token))));
                                    } else if (logado.status == 2) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeCliente(
                                                  user.id,
                                                  user.nome,
                                                  user.email,
                                                  user.status,
                                                  Api())));
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    dialog.showAlertDialog(
                                        context, 'Aviso', 'Login inválido');
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
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
