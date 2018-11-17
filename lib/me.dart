import 'package:flutter/material.dart';
import 'Staff.dart';

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
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text(staff.pname),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.phone),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.email),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.qq),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.wx),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.gxtAccount),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.workAddress),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(staff.birthday),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    );
  }
}