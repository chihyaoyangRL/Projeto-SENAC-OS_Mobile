import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/item_pedido_helper.dart';
import 'package:ordem_services/utils/Dialogs.dart';
import 'package:ordem_services/utils/connect.dart';

class Information_Cliente_Servico extends StatefulWidget {
  final Api api;
  final dynamic id;

  Information_Cliente_Servico(this.api, this.id);

  @override
  _Information_Cliente_ServicoState createState() =>
      _Information_Cliente_ServicoState();
}

class _Information_Cliente_ServicoState
    extends State<Information_Cliente_Servico> {
  List<Item_Pedido> item = List();
  Dialogs dialog = new Dialogs();
  Connect connect = new Connect();
  bool isLoading = false;
  dynamic total = 0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    connect.check().then((intenet) {
      if (intenet != null && intenet) {
        print("connect");
        _getItem();
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
      appBar: AppBar(
        title: Text("Serviço feito"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: WillPopScope(
        child: (isLoading)
            ? new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              )
            : ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return _itemCard(context, index);
                }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _showModalSheet,
        child: Icon(Icons.keyboard_arrow_down),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _itemCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        child: ListTile(
          title: Text((index + 1).toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(item[index].Servico,
                  style: TextStyle(color: Colors.lightBlue)),
            ],
          ),
          trailing: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text('Valor: ' + item[index].Precos,
                style: TextStyle(color: Colors.indigoAccent)),
          ),
        ),
      ),
    );
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 50,
            color: Colors.lightBlue,
            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Valor total: " + 'R\$ ' + total.toStringAsFixed(2),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getItem() async {
    await widget.api.getItem(widget.id).then((list) {
      setState(() {
        item = list;
        isLoading = false;
      });
    });

    item.forEach((f) {
      total += double.parse(f.Precos);
    });
  }
}
