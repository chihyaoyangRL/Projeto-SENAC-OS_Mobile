import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/cadastro_pedido_helper.dart';
import 'package:ordem_services/helper/cliente_helper.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:ordem_services/helper/status_helper.dart';
import 'package:ordem_services/helper/tipo_helper.dart';
import 'package:ordem_services/tabbar.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';
import 'package:ordem_services/utils/validator.dart';
import 'package:random_string/random_string.dart';
import 'package:validators/validators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CadastroPedido extends StatefulWidget {
  final Api api;
  int login_id;
  String nome;
  String email;
  dynamic status;

  CadastroPedido(this.api, this.login_id, this.nome, this.email, this.status);

  @override
  _CadastroPedidoState createState() => _CadastroPedidoState();
}

class _CadastroPedidoState extends State<CadastroPedido> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  final _telefoneController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _defeitoController = TextEditingController();
  final _descricaoController = TextEditingController();

  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  LoginHelper helper = LoginHelper();
  Cadastro_Pedido pedido;
  Cadastro_Pedido _editedpedido;
  Cliente cliente;
  Cliente _editedcliente;
  bool isLoading = false;

//Enviar msg pelo whatsapp
  var email;
  var telefone;
  var password;

  //DropDown
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
    if (pedido == null || cliente == null) {
      _editedpedido = Cadastro_Pedido();
      _editedcliente = Cliente();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('New Pedido'),
        centerTitle: true,
      ),
      drawer: DrawerMenu(widget.nome, widget.email, widget.status),
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
                        "Dados do Cliente",
                        style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                        textAlign: TextAlign.left,
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
                          _editedcliente.nome = text;
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
                          _editedcliente.email = text;
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
                          _editedcliente.telefone = text;
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
                          _editedcliente.cpf = text;
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
                            if (isEmail(_emailController.text)) {
                              if (isNumeric(_telefoneController.text)) {
                                if (CPFValidator.isValid(_cpfController.text)) {
                                  connect.check().then((intenet) async {
                                    if (intenet != null && intenet) {
                                      print("connect");
                                      _editedcliente.password =
                                          randomAlphaNumeric(8);
                                      password = _editedcliente.password;
                                      if (await widget.api.cadastrarNewPedido(
                                              _editedcliente,
                                              _editedpedido,
                                              widget.login_id) !=
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
                                                    TabBarMenu(
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
                                            'Pedido não cadastrado verifica se o email já está cadastrado');
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
                    ),
            ],
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
}
