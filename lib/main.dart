import 'package:flutter/material.dart';
import 'login.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:my_app/Company.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Basics',
      initialRoute: '/login',
      routes: {
        '/': (context) => MyHomePage(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext context;
  int _selectedIndex = 1;
  final _widgetOptions = [
    ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: list,
    ),
    Text('Index 1: Business'),
    Text('Index 2: School'),
  ];

  @override
  Widget build(BuildContext context) {
    getCompany();

    return Scaffold(
      appBar: AppBar(
        title: Text('BottomNavigationBar Sample'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('Business')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }

  void getCompany() async {
    Response response = await api.listCompany(0);
    print(response.data);
    List<Company> companys = Company.buildList(response.data);
    for (Company company in companys) {
      list.add(ListTile(
        title: Text(company.getName,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
        subtitle: Text('85 W Portal Ave'),
        leading: Icon(
          Icons.theaters,
          color: Colors.blue[500],
        ),
      ));
    }

    print(companys);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}*/

List<Widget> list = <Widget>[
  ListTile(
    title: Text('CineArts at the Empire',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: Text('85 W Portal Ave'),
    leading: Icon(
      Icons.theaters,
      color: Colors.blue[500],
    ),
  ),
];
/*

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 5.0, // Removing the drop shadow cast by the app bar.
      ),
      body: Center(
        child: ListView(
          children: list,
        ),
      ),
    );
  }
}*/
