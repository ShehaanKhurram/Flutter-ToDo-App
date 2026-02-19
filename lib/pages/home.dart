import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:todo_app/components/dialog_box.dart";
import "package:todo_app/components/todo_tile.dart";
import "package:todo_app/data/database.dart";

enum MenuItems { clear, deleteCompleted, sort }

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

  void clearAllTasks() {
    setState(() {
      db.todoTasks.clear();
    });
    db.updateTasks();
  }

  void deleteCompletedTasks() {
    setState(() {
      db.todoTasks.removeWhere((task) => task[1] == true);
    });
    db.updateTasks();
  }

  void sortTaskByName() {
    setState(() {
      db.todoTasks.sort(
        (a, b) => a[0].toString().toLowerCase().compareTo(
          b[0].toString().toLowerCase(),
        ),
      );
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
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == MenuItems.clear) {
                clearAllTasks();
              } else if (value == MenuItems.deleteCompleted) {
                deleteCompletedTasks();
              } else if (value == MenuItems.sort) {
                sortTaskByName();
              }
            },
            itemBuilder: (context) => [
              // option 1 clear All Tasks
              PopupMenuItem(
                value: MenuItems.clear,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.black),
                    SizedBox(width: 5),
                    Text("Clear All Tasks"),
                  ],
                ),
              ),
              // option 2 delete completed tasks
              PopupMenuItem(
                value: MenuItems.deleteCompleted,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 5),
                    Text("delete_completed"),
                  ],
                ),
              ),
              // option 3 sort tasks by name
              PopupMenuItem(
                value: MenuItems.sort,
                child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text("Sort Tasks by name"),
                ),
              ),
            ],
          ),
          Icon(Icons.favorite),
          Icon(Icons.favorite),
          Icon(Icons.favorite),
        ],
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
