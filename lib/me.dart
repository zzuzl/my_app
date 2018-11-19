import 'package:flutter/material.dart';
import 'Staff.dart';
import 'MyIcon.dart';

class MePage extends StatelessWidget {
  final Staff staff;

  MePage(this.staff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(staff.name,
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(staff.workType),
            leading: Icon(
              Icons.contacts,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text(staff.pname),
            leading: Icon(
              Icons.domain,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.phone),
            leading: Icon(
              Icons.call,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.email),
            leading: Icon(
              Icons.email,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.qq),
            leading: Icon(
              MyIcon.qq,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.wx),
            leading: Icon(
              MyIcon.wx,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.gxtAccount),
            leading: Icon(
              Icons.account_box,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.workAddress),
            leading: Icon(
              Icons.location_on,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.birthday),
            leading: Icon(
              Icons.cake,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    );
  }
}