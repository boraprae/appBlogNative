import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

// class Controller extends GetxController {
//   var count = 0.obs;
//   increment() => count++;
// }

class _TestState extends State<Test> {
  var data = [
    {'title': 'First', 'detail': 'aaa'},
    {'title': 'Second', 'detail': 'bbb'},
    {'title': 'Third', 'detail': 'ccc'},
  ];

  Future deleteBlog(index) async {
    await Get.defaultDialog(
        title: 'Warning',
        middleText: 'Sure to delete?',
        textConfirm: 'Yes',
        textCancel: 'Cancel',
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.black,
        buttonColor: Colors.red,
        onConfirm: () {
          setState(() {
            data.removeAt(index);
            Get.back();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF432818),
        title: Text("Blog"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              //List view builder
              child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  title: Text("${data[index]["title"]}"),
                  subtitle: Text("${data[index]["detail"]}"),
                  trailing: IconButton(
                    onPressed: () {
                      print("test");
                      deleteBlog(index);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              );
            },
          ))
        ],
      )),
    );
  }
}