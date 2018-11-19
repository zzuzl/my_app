import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Staff.dart';
import 'MyIcon.dart';

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({Key key, this.lines})
      : assert(lines.length > 0),
        super(key: key);

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[
      Text(lines.first == null ? '' : lines.first,
          style: TextStyle(fontWeight: FontWeight.w300))
    ];

    final List<Widget> rowChildren = <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren))
    ];

    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}

class ContactsDemo extends StatefulWidget {
  final Staff staff;

  ContactsDemo(this.staff);

  @override
  ContactsDemoState createState() => ContactsDemoState(this.staff);
}

class ContactsDemoState extends State<ContactsDemo> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  final Staff staff;

  ContactsDemoState(this.staff);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(staff.name + '(${staff.gender})'),
                background: Stack(
                  fit: StackFit.expand,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _ContactCategory(
                  icon: Icons.contacts,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.pname,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.domain,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.workType,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.cake,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.birthday,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.email,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.email,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: MyIcon.qq,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.qq,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: MyIcon.wx,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.wx,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.account_box,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.gxtAccount,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.call,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.phone,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.location_on,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.workAddress,
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.school,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        staff.school,
                      ],
                    ),
                    _ContactItem(
                      lines: <String>[
                        staff.major,
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
