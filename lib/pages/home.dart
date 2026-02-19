import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:todo_app/components/dialog_box.dart";
import "package:todo_app/components/todo_tile.dart";
import "package:todo_app/data/database.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _myBox = Hive.box('myBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if (_myBox.get("TODOTASKS") == null) {
      db.createInitialTasks();
    } else {
      db.loadTasks();
    }
    super.initState();
  }

  final myController = TextEditingController();

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todoTasks[index][1] = !db.todoTasks[index][1];
    });
    db.updateTasks();
  }

  void addNewTask() {
    setState(() {
      db.todoTasks.add([myController.text, false]);
      myController.clear();
    });
    Navigator.of(context).pop();
    db.updateTasks();
  }

  void addButtonTapped() {
    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: myController,
            onSave: addNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        },
      );
    });
  }

  void deleteTask(int index) {
    setState(() {
      db.todoTasks.removeAt(index);
    });
    db.updateTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          "To DO",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonTapped,
        backgroundColor: Colors.blue[500],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todoTasks.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.todoTasks[index][0],
            checkBoxClicked: db.todoTasks[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            deleteTask: (value) => deleteTask(index),
          );
        },
      ),
    );
  }
}
