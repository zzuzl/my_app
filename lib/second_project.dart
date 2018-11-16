import 'package:flutter/material.dart';
import 'Project.dart';
import 'Staff.dart';

class SecondProjectPage extends StatelessWidget {
  final List<Project> projectList;
  final List<Staff> staffList;

  SecondProjectPage({Key key, @required this.projectList, @required this.staffList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    for(Project c in projectList) {
      list.add(ListTile(
          leading: new CircleAvatar(child: new Text(c.getName)),
          title: new Text(c.getName),
          subtitle: new Text(c.getName))
      );
    }

    for(Staff s in staffList) {
      list.add(ListTile(
          leading: new CircleAvatar(child: new Text(s.getName)),
          title: new Text(s.getName),
          subtitle: new Text(s.getName))
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('First Screen'),
        ),
        body: ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: list,
        )
    );
  }
}