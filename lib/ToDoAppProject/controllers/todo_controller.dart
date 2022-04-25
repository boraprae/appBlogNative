import 'package:get/get.dart';
import 'package:newblog/ToDoAppProject/models/todo.dart';

class TodoController extends GetxController {
  //example
  //List bb = [Todo(title: 'task1'), Todo(title:'task2)]
  //List<Todo> todos = [];

  var todos = <Todo>[].obs;
  //Logics here
  void add(String title) {
    todos.add(Todo(title: title));
  }

  void edit(String text, int index) {
    //todos[index].title = text;
    //1.get the selected task
    var task = todos[index];
    //2. update the member's property
    task.title = text;
    //3. update array's member
    todos[index] = task;
  }

  //toggle task's status
  void toggle(int index) {
    // todos[index].status = !todos[index].status;
    var task = todos[index];
    task.status = !task.status;
    todos[index] = task;
  }
}
