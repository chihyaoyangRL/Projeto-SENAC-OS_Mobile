import 'package:flutter/material.dart';
import 'package:ordem_services/helper/tipo_helper.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:flutter/services.dart';

class UpdateTipo extends StatefulWidget {
  final Tipo tipo;
  final login_id;

  UpdateTipo(this.tipo, this.login_id);

  @override
  _UpdateTipoState createState() => _UpdateTipoState();
}

class _UpdateTipoState extends State<UpdateTipo> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  Tipo _editedtipo;
  bool isLoading = false;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    _editedtipo = Tipo.fromJson(widget.tipo.toJson());
    _typeController.text = _editedtipo.type;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Alterar Tipo'),
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
                        hintText: " Type",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.style,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedtipo.type = text;
                      },
                      controller: _typeController,
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
                        connect.check().then((intenet) {
                          if (intenet != null && intenet) {
                            print("connect");
                            Navigator.pop(context, _editedtipo);
                          } else {
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
