import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newblog/ToDoAppProject/controllers/todo_controller.dart';

class TodoUpdateScreen extends StatelessWidget {
  TodoUpdateScreen({Key? key}) : super(key: key);
  TextEditingController tcTitle = TextEditingController();
  TodoController todoController = Get.find();

  @override
  Widget build(BuildContext context) {
    //get index of selected task from main screen
    int? index = Get.arguments;
    if (index != null) {
      //edit case
      tcTitle.text = todoController.todos[index].title;
    }
    // print(index);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TextField(
                maxLines: 50,
                controller: tcTitle,
                autofocus: true,
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Task message',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (index == null) {
                      todoController.add(tcTitle.text);
                    } else {
                      todoController.edit(tcTitle.text, index);
                    }

                    //return to main screen
                    Get.back();
                  },
                  child: index == null ? const Text('Add') : const Text('Edit'),
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
