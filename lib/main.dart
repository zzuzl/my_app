import 'package:flutter/material.dart';
import 'login.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'Company.dart';
import 'Project.dart';
import 'Staff.dart';
import 'second_company.dart';
import 'second_project.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Basics',
      initialRoute: '/login',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => LoginPage()
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
  int _selectedIndex = 0;
  List<Company> companyList;
  List<Project> projectList;

  @override
  void initState() {
    super.initState();
    this.getCompany(0);
  }

  Widget buildIndex() {
    if (_selectedIndex == 0) {
      return _buildIndex(companyList);
    } else if (_selectedIndex == 1) {
      return _buildIndex(projectList);
    } else {
      return _buildIndex(companyList);
    }
  }

  Widget _buildIndex(List list) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: Text(list[index].getName,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                    subtitle: Text('85 W Portal Ave'),
                    leading: Icon(
                      Icons.theaters,
                      color: Colors.blue[500],
                    ),
                    onTap: () async {
                      int id = list[index].getId;
                      Response _response = await api.listStaff(id, 1, _selectedIndex == 0 ? 1 : 2);

                      if (_selectedIndex == 0) {
                        Response response = await api.listCompany(id);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SecondCompanyPage(
                              companyList: Company.buildList(response.data['data']),
                            staffList: Staff.buildList(_response.data['data']),
                          ),
                        ));
                      } else if (_selectedIndex == 1) {
                        Response response = await api.listProject(id);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SecondProjectPage(
                              projectList: Project.buildList(response.data['data']),
                            staffList: Staff.buildList(_response.data['data']),
                          ),
                        ));
                      }
                    }
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BottomNavigationBar Sample'),
      ),
      body: buildIndex(),
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

  void getCompany(int index) async {
    Response response = await api.listCompany(0);
    List<Company> companys = Company.buildList(response.data['data']);

    setState(() {
      _selectedIndex = index;
      this.companyList = companys;
    });
  }

  void getProject(int index) async {
    Response response = await api.listProject(0);
    List<Project> projects = Project.buildList(response.data['data']);

    setState(() {
      _selectedIndex = index;
      this.projectList = projects;
    });
  }

  void _onTitleTapped(BuildContext context) {

  }

  void _onItemTapped(int index) {
    if (index == 0) {
      getCompany(index);
    } else if (index == 1) {
      getProject(index);
    } else {
      getCompany(index);
    }
  }
}
