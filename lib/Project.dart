import 'dart:convert';
import 'demo.dart';

class Project extends Category{
  int id;
  int pid;

  String get getName => name;
  int get getId => id;

  Project(Map map) : super.fromMap(map['name'], new List()) {
    this.id = map['id'];
    this.pid = map['pid'];
  }

  static List<Project> buildList(List list) {
    List<Project> projects = new List();
    if (list == null) {
      return projects;
    }
    for (Map map in list) {
      projects.add(new Project(map));
    }
    return projects;
  }

  static List<Project> buildListFromString(List<String> list) {
    List<Project> projects = new List(list.length);
    for (String str in list) {
      Map map = jsonDecode(str);
      projects.add(new Project(map));
    }
    return projects;
  }

  @override
  String toString() {
    return 'Project{id: $id, name: $name, pid: $pid}';
  }

}