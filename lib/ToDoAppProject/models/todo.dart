class Todo {
  String title;
  bool status;

  //? Constructor
  // 1st way
  // Todo(String title, bool status) {
  //   this.title = title;
  //   this.status = status;
  // }

  //2nd way
  // Todo(this.title, this.status);

  //3rd way
  Todo({required this.title, this.status = false});
  //Todo(title: 'task1', status: false)
}
