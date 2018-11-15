import 'dart:convert';

class Company {
  int id;
  String name;
  int pid;

  String get getName => name;

  Company(Map map) {
    this.id = map['id'];
    this.name = map['name'];
    this.pid = map['pid'];
  }

  static List<Company> buildList(List<Map> list) {
    List<Company> companys = new List(list.length);
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