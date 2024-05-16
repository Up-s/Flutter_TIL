import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todolist/create_screen.dart';
import 'package:todolist/todo.dart';
import 'package:todolist/todo_item.dart';

import 'main.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: ListView(
          children: todos.values
              .map((todo) => TodoItem(
                    todo: todo,
                    onTap: (e) async {
                      e.isDone = !e.isDone;
                      await e.save();
                      setState(() {});
                    },
                    onDelete: (e) async {
                      await e.delete();
                      setState(() {});
                    },
                  ))
              .toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateScreen(),
            ),
          );

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
