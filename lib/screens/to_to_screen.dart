import 'package:flutter/material.dart';
import 'package:notevault/screens/pin_code_change_screen.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/TodoItem.dart';
import 'package:intl/intl.dart';

class ToDoScreen extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();

  void _handleUpdateTodo(Todoitem todo, TodoProvider todoProvider) {
    todoProvider.updateTodo(Todoitem(
      id: todo.id,
      content: todo.content,
      completed: !todo.completed,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.3,
                image: AssetImage('assets/bg_pattern_1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.2),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60.0, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To-Do List',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B506D),
                          ),
                        ),
                        Text(
                          'Хийсэн ажлуудаа check-лээрэй ❤️',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3B506D),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PinCodeChangeScreen()),
                          );
                        },
                        child:
                            const Icon(Icons.settings, color: Colors.black54)),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: todoProvider.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoProvider.todos[index];
                    return InkWell(
                      onTap: () => _handleUpdateTodo(todo, todoProvider),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (value) {
                            todoProvider.updateTodo(Todoitem(
                              id: todo.id,
                              content: todo.content,
                              completed: value!,
                            ));
                          },
                        ),
                        title: Text(
                          todo.content,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: todo.completed ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3E7C78),
        onPressed: () => _showAddTaskDialog(context, todoProvider),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TodoProvider todoProvider) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 20,
              child: SizedBox(
                height: 320,
                child: Image.asset(
                  'assets/yellow_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Dialog box
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Хийх зүйл',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B506D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        hintText: 'Бичих...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_taskController.text.isNotEmpty) {
                            await todoProvider.addTodo(Todoitem(
                              content: _taskController.text,
                              completed: false,
                            ));
                            _taskController.clear();
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E7C78),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Болсон',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
