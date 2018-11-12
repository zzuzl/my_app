import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Navigation Basics', home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('First Screen'),
        ),
        body: Column(
            children: list
        )
    );
  }
}

List<Widget> list = <Widget>[
  Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          leading: Icon(Icons.album),
          title: Text('The Enchanted Nightingale'),
          subtitle: Text(
              'Music by Julie Gable. Lyrics by Sidney Stein.'),
        )
      ],
    ),
  ),
  ListTile(
    title: Text('CineArts at the Empire',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: Text('85 W Portal Ave'),
    leading: Icon(
      Icons.theaters,
      color: Colors.blue[500],
    ),
  ),
  ListTile(
    title: Text('The Castro Theater',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: Text('429 Castro St'),
    leading: Icon(
      Icons.theaters,
      color: Colors.blue[500],
    ),
  )
];
