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
import 'me.dart';

class MyHomePage extends StatefulWidget {
  final Staff staff;
  MyHomePage({Key key, @required this.staff}) : super(key: key);

  Staff getMe() => staff;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Company> companyList;
  List<Project> projectList;
  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();
  int _lastIntegerSelected;

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
      return MePage(widget.getMe());
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
                    // subtitle: Text('85 W Portal Ave'),
                    leading: Icon(
                      Icons.theaters,
                      color: Colors.blue[500],
                    ),
                    onTap: () async {
                      int id = list[index].getId;
                      Response _response = await api.listStaff(id, 1, _selectedIndex == 0 ? 0 : 1);

                      if (_selectedIndex == 0) {
                        Response response = await api.listCompany(id);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SecondCompanyPage(
                            company: list[index],
                            companyList: Company.buildList(response.data['data']),
                            staffList: Staff.buildList(_response.data['data']),
                          ),
                        ));
                      } else if (_selectedIndex == 1) {
                        Response response = await api.listProject(id);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SecondProjectPage(
                            project: list[index],
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
        title: Text('ZL'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final int selected = await showSearch<int>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null && selected != _lastIntegerSelected) {
                setState(() {
                  _lastIntegerSelected = selected;
                });
              }
            },
          ),
        ],
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

class _SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<int> _data = List<int>.generate(100001, (int i) => i).reversed.toList();
  final List<int> _history = <int>[42607, 85604, 66374, 44, 174];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final Iterable<int> suggestions = query.isEmpty
        ? _history
        : _data.where((int i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map<String>((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int searched = int.tryParse(query);
    if (searched == null || !_data.contains(searched)) {
      return Center(
        child: Text(
          '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: <Widget>[
        _ResultCard(
          title: 'This integer',
          integer: searched,
          searchDelegate: this,
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int integer;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, integer);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              Text(
                '$integer',
                style: theme.textTheme.headline.copyWith(fontSize: 72.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
