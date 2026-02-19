import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool checkBoxClicked;
  void Function(bool?)? onChanged;
  void Function(BuildContext)? deleteTask;

  TodoTile({
    super.key,
    required this.taskName,
    required this.checkBoxClicked,
    required this.onChanged,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteTask,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // checkBox
              Checkbox(
                value: checkBoxClicked,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              // Task name
              Text(
                taskName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: checkBoxClicked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
