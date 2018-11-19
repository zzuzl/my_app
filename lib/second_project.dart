import 'package:flutter/material.dart';
import 'Project.dart';
import 'Staff.dart';
import 'staff_info.dart';

class SecondProjectPage extends StatelessWidget {
  final Project project;
  final List<Project> projectList;
  final List<Staff> staffList;

  SecondProjectPage(
      {Key key,
      @required this.project,
      @required this.projectList,
      @required this.staffList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (Project c in projectList) {
      list.add(ListTile(
          leading: new CircleAvatar(child: new Text(c.getName)),
          title: new Text(c.getName),
          subtitle: new Text(c.getName)));
    }

    for (Staff s in staffList) {
      list.add(
        ListTile(
            leading: new CircleAvatar(child: new Text(String.fromCharCode(s.name.codeUnitAt(0)))),
            title: new Text(s.name),
            subtitle: new Text(s.workType),
            onTap: () {
              s.setPname(project.getName);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactsDemo(s)));
            }),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(project.getName),
        ),
        body: ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: list,
        ));
  }
}
