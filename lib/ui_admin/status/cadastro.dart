import 'package:flutter/material.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/helper/status_helper.dart';
import 'package:ordem_services/tabbar_status.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CadastroStatus extends StatefulWidget {
  String nome;
  String email;
  dynamic status;

  CadastroStatus(this.nome, this.email, this.status);

  @override
  _CadastroStatusState createState() => _CadastroStatusState();
}

class _CadastroStatusState extends State<CadastroStatus> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _statusController = TextEditingController();
  LoginHelper helper = LoginHelper();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  Api api = new Api();
  Status status;
  Status _editedStatus;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (status == null) {
      _editedStatus = Status();
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
        title: Text('Cadastrar Status'),
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
                      hintText: " Status",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Container(
                        child: Icon(
                          Icons.assistant,
                          color: Colors.white,
                        ),
                        color: Colors.blue,
                      ),
                    ),
                    onChanged: (text) {
                      _editedStatus.status = text;
                    },
                    controller: _statusController,
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
                            connect.check().then((intenet) async {
                              if (intenet != null && intenet) {
                                print("connect");
                                if (await api.cadastrarStatus(_editedStatus) !=
                                    null) {
                                  Logado logado = await helper.getLogado();
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TabBarStatus(
                                              logado.logado_login_id,
                                              logado.nome,
                                              logado.email,
                                              logado.status,
                                              Api(token: logado.token))));
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  dialog.showAlertDialog(
                                      context, 'Aviso', 'Falha ao cadastrar');
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
              ],
            )),
      ),
    );
  }
}
