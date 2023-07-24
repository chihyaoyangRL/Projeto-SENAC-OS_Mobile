import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ordem_services/screen/login.dart';
import 'package:ordem_services/screen/login2.dart';
import 'package:ordem_services/helper/Api.dart';
import 'package:ordem_services/helper/login_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class TabBarLogin extends StatefulWidget {
  final Login login;
  final Api api;

  TabBarLogin({this.login, this.api, Key key}) : super(key: key);

  @override
  _TabBarLoginState createState() => _TabBarLoginState();
}

class _TabBarLoginState extends State<TabBarLogin> {
  //目前選擇頁索引值 index(Página) atual
  int _currentIndex = 0; //預設值
  List<Widget> pages() => [
        LoginPage(),
        LoginPage2(),
      ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> page = pages();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/login_image.jpg",
            fit: BoxFit.cover,
            height: 1000,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 10.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/ic_launcher.png'),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Container(
                      child: page[_currentIndex],
                      height: 250,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple,
        items: <Widget>[
          Icon(Icons.email, size: 30),
          Icon(Icons.phone, size: 30),
        ],
        color: Colors.greenAccent,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
    );
  }
}
