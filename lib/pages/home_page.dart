import 'package:flutter/material.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/utils/todo_tile.dart';
import 'package:to_do_app/utils/dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('myBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get('ToDoList') == null) {
      db.createInititalData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      // todolist[index][1] = !todolist[index][1];
      db.todolist[index][1] = value;
    });
    db.updateData();
  }

  void savetask() {
    setState(() {
      db.todolist.add([controller.text, false]);
    });
    Navigator.pop(context);
    db.updateData();
  }

  void deleteToDoItem(BuildContext context, int index) {
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            textController: controller,
            onSave: savetask,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade200,
      appBar: AppBar(
        title: const Center(
            child: Text(
          "TO DO",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        shape: const CircleBorder(),
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todolist.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.todolist[index][0],
            taskCompleted: db.todolist[index][1],
            onChanged: (value) {
              checkBoxChanged(value, index);
            },
            deleteFunction: (context) => deleteToDoItem(context, index),
          );
        },
      ),
    );
  }
}
