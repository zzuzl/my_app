import 'package:flutter/material.dart';
import 'Project.dart';
import 'Staff.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';

class SecondProjectPage extends StatefulWidget {
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
  _SecondProjectPageState createState() => _SecondProjectPageState();
}

class _SecondProjectPageState extends State<SecondProjectPage> {
  ScrollController _scrollController = new ScrollController();
  int _page = 2;
  bool _request = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
        && widget.staffList.length >= 20 && _page > 1) {
        getMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getMore() async {
    setState(() {
      _request = true;
    });

    List<Staff> list;
    Response response = await api.listStaff(widget.project.id, _page, 1);
    if (response.data['success']) {
      list = Staff.buildList(response.data['data']);
      if (list == null || list.length < 1) {
        _page = -1;
        setState(() {
          _request = false;
        });
        return;
      }
    }
    _page ++;

    if (list != null) {
      setState(() {
        _request = false;
        widget.staffList.addAll(list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.project.getName),
        ),
        body: ListView.builder(
          itemCount: widget.staffList.length,
          itemBuilder: (context, index) {
            if (index == widget.staffList.length) {
              return _buildProgressIndicator();
            } else {
              return ListTile(
                  leading: new CircleAvatar(child: new Text(String.fromCharCode(widget.staffList[index].name.codeUnitAt(0)))),
                  title: new Text(widget.staffList[index].name),
                  subtitle: new Text(widget.staffList[index].workType),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ContactsDemo(widget.staffList[index])));
                  });
            }
          },
          controller: _scrollController,
        )
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _request ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
