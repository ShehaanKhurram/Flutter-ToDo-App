import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  final _myBox = Hive.box('myBox');

  List todoTasks = [];

  void createInitialTasks() {
    todoTasks = [
      ["Sample Task", false],
    ];
  }

  void loadTasks() {
    todoTasks = _myBox.get("TODOTASKS");
  }

  void updateTasks() {
    _myBox.put("TODOTASKS", todoTasks);
  }
}
