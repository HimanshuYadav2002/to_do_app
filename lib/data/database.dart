import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  final _myBox = Hive.box('myBox');

  List todolist = [];

  void createInititalData() {
    todolist = [
      ["Make tutorial", false],
      ["Make breakfast", false],
    ];
  }

  void loadData() {
    todolist = _myBox.get('ToDoList');
  }

  void updateData() {
    _myBox.put('ToDoList', todolist);
  }
}
