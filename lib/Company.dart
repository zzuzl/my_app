import 'dart:convert';
import 'demo.dart';

class Company extends Category {
  int id;
  String name;
  int pid;

  String get getName => name;
  int get getId => id;

  Company(Map map) : super.fromMap(map['name'], new List()) {
    this.id = map['id'];
    this.pid = map['pid'];
  }

  static List<Company> buildList(List list) {
    List<Company> companys = new List();
    if (list == null) {
      return companys;
    }

    for (Map map in list) {
      companys.add(new Company(map));
    }
    return companys;
  }

  static List<Company> buildListFromString(List<String> list) {
    List<Company> companys = new List(list.length);
    for (String str in list) {
      Map map = jsonDecode(str);
      companys.add(new Company(map));
    }
    return companys;
  }

  @override
  String toString() {
    return 'Company{id: $id, name: $name, pid: $pid}';
  }

}