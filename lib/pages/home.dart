import "package:flutter/material.dart";
import "package:todo_app/components/dialog_box.dart";
import "package:todo_app/components/todo_tile.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();
  final List todoTasks = [
    ["Sample Task", false],
  ];

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todoTasks[index][1] = !todoTasks[index][1];
    });
  }

  void addNewTask() {
    setState(() {
      todoTasks.add([myController.text, false]);
      myController.clear();
    });
    Navigator.of(context).pop();
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
      todoTasks.removeAt(index);
    });
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
        itemCount: todoTasks.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: todoTasks[index][0],
            checkBoxClicked: todoTasks[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            deleteTask: (value) => deleteTask(index),
          );
        },
      ),
    );
  }
}
