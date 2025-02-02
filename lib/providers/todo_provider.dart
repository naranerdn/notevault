import 'package:flutter/material.dart';
import 'package:notevault/models/TodoItem.dart';
import '../db/database_helper.dart';
import '../models/note.dart';

class TodoProvider with ChangeNotifier {
  List<Todoitem> _todos = [];

  List<Todoitem> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await DatabaseHelper.instance.fetchTodos();
    print(_todos);
    for (int i = 0; _todos.length > i; i++) {
      print(_todos[i].content + " - " + _todos[i].completed.toString());
    }
    notifyListeners();
  }

  Future<void> addTodo(Todoitem todo) async {
    await DatabaseHelper.instance.insertTodo(todo);
    await loadTodos();
  }

  Future<void> deleteTodoById(int id) async {
    await DatabaseHelper.instance.deleteTodoById(id);
    await loadTodos();
  }

  Future<void> updateTodo(Todoitem todo) async {
    await DatabaseHelper.instance.updateTodo(todo);
    await loadTodos();
  }
}
