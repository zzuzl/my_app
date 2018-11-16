import 'package:flutter/material.dart';
import 'Company.dart';
import 'Staff.dart';
import 'staff_info.dart';

class SecondCompanyPage extends StatelessWidget {
  final List<Company> companyList;
  final List<Staff> staffList;

  SecondCompanyPage({Key key, @required this.companyList, @required this.staffList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    for(Company c in companyList) {
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
          subtitle: new Text(s.getName),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ContactsDemo()));
          },
      ));
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
