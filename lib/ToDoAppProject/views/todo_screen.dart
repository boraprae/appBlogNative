import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newblog/ToDoAppProject/controllers/todo_controller.dart';
import 'package:newblog/ToDoAppProject/views/todo_update_screen.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({Key? key}) : super(key: key);
  TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: Obx(() => ListView.separated(
          itemBuilder: (context, index) => ListTile(
                leading: Checkbox(
                  value: todoController.todos[index].status,
                  onChanged: (value) {
                    todoController.toggle(index);
                  },
                ),
                title: Text(
                  todoController.todos[index].title,
                  style: todoController.todos[index].status
                      ? TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough)
                      : TextStyle(color: Colors.black),
                ),
                trailing: IconButton(
                  onPressed: () {
                    //go to edit page with selected index
                    Get.to(() => TodoUpdateScreen(), arguments: index);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: todoController.todos.length)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => TodoUpdateScreen());
        },
      ),
    );
  }
}
