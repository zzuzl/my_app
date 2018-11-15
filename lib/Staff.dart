import 'dart:convert';

class Staff {
  int id;
  String name;
  int pid;

  String get getName => name;
  int get getId => id;

  Staff(Map map) {
    this.id = map['id'];
    this.name = map['name'];
    this.pid = map['pid'];
  }

  static List<Staff> buildList(List list) {
    List<Staff> staffs = new List();
    for (Map map in list) {
      staffs.add(new Staff(map));
    }
    return staffs;
  }

  @override
  String toString() {
    return 'Staff{id: $id, name: $name, pid: $pid}';
  }


}