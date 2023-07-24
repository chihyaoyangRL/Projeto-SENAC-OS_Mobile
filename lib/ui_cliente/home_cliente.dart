import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/cadastro_pedido_helper.dart';
import 'package:ordem_services/ui_cliente/infor_service.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';
import 'package:ordem_services/utils/menu.dart';

class HomeCliente extends StatefulWidget {
  int login_id;
  String nome;
  String email;
  dynamic status;
  final Api api;

  HomeCliente(this.login_id, this.nome, this.email, this.status, this.api);

  @override
  _HomeClienteState createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  List<Cadastro_Pedido> pedido = List();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _getAllPedidos();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
        title: Text("Serviço Solicitado"),
        centerTitle: true,
      ),
      drawer: DrawerMenu(widget.nome, widget.email, widget.status),
      body: WillPopScope(
        child: (isLoading)
            ? new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              )
            : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: pedido.length,
                itemBuilder: (context, index) {
                  return _itemCard(context, index);
                }),
      ),
    );
  }

  Widget _itemCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Nome: ' + pedido[index].Cliente,
                  overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Divider(),
                  Text('Tipo: ' + pedido[index].Tipo,
                      overflow: TextOverflow.ellipsis),
                  Text('Status: ' + pedido[index].Status,
                      overflow: TextOverflow.ellipsis),
                  Text('Data foi cadastrado: ' + pedido[index].data_pedido,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
              trailing: (pedido[index].Status == "Pronto a entrega")
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.report_problem, color: Colors.red),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    List<Widget> botoes = [];
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.visibility, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Visualizar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  Information_Cliente_Servico(widget.api, pedido[index].id)),
        );
      },
    ));
    dialog.showBottomOptions(context, botoes);
  }

  _getAllPedidos() {
    connect.check().then((intenet) async {
      if (intenet != null && intenet) {
        print("connect");
        await widget.api
            .getClientPedido(widget.login_id.toString())
            .then((list) {
          setState(() {
            pedido = list;
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
