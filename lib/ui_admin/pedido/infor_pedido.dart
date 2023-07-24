import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Information_Pedido extends StatefulWidget {
  final dynamic id;
  final dynamic Cliente;
  final dynamic Tipo;
  final dynamic Status;
  final dynamic Funcionario;
  final String marca;
  final String modelo;
  final String defeito;
  final String descricao;
  final dynamic data_pedido;

  Information_Pedido(
      this.id,
      this.Cliente,
      this.Tipo,
      this.Status,
      this.Funcionario,
      this.marca,
      this.modelo,
      this.defeito,
      this.descricao,
      this.data_pedido);

  @override
  _Information_PedidoState createState() => _Information_PedidoState();
}

class _Information_PedidoState extends State<Information_Pedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Cliente),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.greenAccent])),
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Card(
                  margin: new EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(
                      'Id: ' + widget.id.toString(),
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Tipo: ' + widget.Tipo),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Status: ' + widget.Status,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Cadastrado por: ' + widget.Funcionario,
                              style: TextStyle(color: Colors.indigoAccent)),
                        ),
                        Divider(),
                        Container(
                          child: Text('Marca: ' + widget.marca),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Modelo: ' + widget.modelo),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Defeito: ' + widget.defeito,
                              style: TextStyle(color: Colors.indigoAccent)),
                        ),
                        Divider(),
                        Container(
                            child: Text('Descricao: ' + widget.descricao)),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Data: ' + widget.data_pedido,
                              style: TextStyle(color: Colors.indigoAccent)),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
