import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'SearchResult.dart';
import 'staff_info.dart';
import 'Staff.dart';
import 'Company.dart';
import 'Project.dart';
import 'second_company.dart';
import 'second_project.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = new TextEditingController();
  List<SearchResult> _searchResult = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('搜索'),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: '搜索', border: InputBorder.none),
                    onSubmitted: onSearchTextChanged,
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  child: new ListTile(
                    leading: Icon(
                      _searchResult[i].type == 1 ? Icons.contacts : Icons.domain,
                      color: Colors.blue[500],
                    ),
                    title: new Text(_searchResult[i].title),
                    onTap: () async {
                      SearchResult sr = _searchResult[i];
                      if (sr.type == 1) {
                        Response response = await api.getStaff(sr.id);
                        if (response.data['success']) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ContactsDemo(Staff(response.data['data']))));
                        }
                      } else if (sr.type == 2) {
                        Response response = await api.listStaff(sr.id, 1, 0);
                        if (response.data['success']) {
                          Map map = new Map();
                          map.putIfAbsent('name', () => sr.title);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SecondCompanyPage(
                              company: new Company(map),
                              companyList: new List(),
                              staffList: Staff.buildList(response.data['data'])))
                          );
                        }
                      } else if (sr.type == 3) {
                        Response response = await api.listStaff(sr.id, 1, 1);
                        if (response.data['success']) {
                          Map map = new Map();
                          map.putIfAbsent('name', () => sr.title);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SecondProjectPage(
                              project: new Project(map),
                              projectList: new List(),
                              staffList: Staff.buildList(response.data['data'])))
                          );
                        }
                      }
                    },
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    Response response = await api.search(text);
    print(response.data);

    setState(() {
      for(Map map in response.data['data']) {
        _searchResult.add(SearchResult(map['id'], map['type'], map['title']));
      }
    });
  }
}
