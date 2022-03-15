import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blog extends StatefulWidget {
  String? username;
  Blog( this.username ,{Key? key}): super(key: key);

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  //*=========== Data Set ==============
  List data = [
    {'title': 'First', 'detail': 'aaa'},
    {'title': 'Second', 'detail': 'bbb'},
    {'title': 'Third', 'detail': 'ccc'},
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final maxLines = 5;
  final String _url = 'http://10.0.2.2:7000/mobile/blog';
  late Future<List> _data;

  Future<List> getData() async {
    Response response = await GetConnect().get(_url);
    if (response.status.isOk) {
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    _data = getData();
  }

  //?########### Dialog for edit card ###############
  Future showEditDialog(index) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width - 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.library_add,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Edit ' +
                              '\"' +
                              data[index]['title'] +
                              "\"" +
                              ' BLOG',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: 'Enter a title',
                        hintText: data[index]['title'],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: Container(
                      height: maxLines * 24.0,
                      child: TextField(
                        maxLines: maxLines,
                        controller: detailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            helperText: 'Enter a details',
                            hintText: data[index]['detail']),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.limeAccent,
                        ),
                        onPressed: () {
                          updateToDataSet(titleController.text,
                              detailController.text, index);
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  //*########### Edit new data from user #############
  void updateToDataSet(String title, String detail, index) {
    setState(() {
      data[index] = {"title": title, "detail": detail};
      titleController.clear();
      detailController.clear();
      Navigator.of(context).pop();
    });
  }

  //?########### Dialog for add new card ############
  Future showInputDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width - 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.library_add,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Create new BLOG',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter a title',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: Container(
                      height: maxLines * 24.0,
                      child: TextField(
                        maxLines: maxLines,
                        controller: detailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter a details',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.limeAccent,
                        ),
                        onPressed: () {
                          addToDataSet(
                            titleController.text,
                            detailController.text,
                          );
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  //*########### Add new data from user #############
  void addToDataSet(String title, String detail) {
    setState(() {
      data.add(
        {'title': title, 'detail': detail},
      );
      titleController.clear();
      detailController.clear();
      Navigator.of(context).pop();
    });
  }

  //!########### Delete Dialog ##########
  Future deleteDialog(index) async {
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
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text(
          'Blog of ${widget.username}',
          style: TextStyle(
            color: Colors.limeAccent,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: 8),
            child: RaisedButton.icon(
              color: Colors.limeAccent,
              onPressed: () {
                setState(() {
                  showInputDialog();
                });
              },
              icon: Icon(Icons.add),
              label: Text('Add'),
            ),
          ),
          FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List serverData = snapshot.data as List;
                return Expanded(
                  child: ListView.builder(
                    itemCount: serverData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          //*----- Edit Button -----*
                          leading: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showEditDialog(index);
                            },
                          ),
                          title: Text(serverData[index]['title']),
                          subtitle: Text('${serverData[index]['detail']}'),
                          //!----- Delete Button ------!
                          trailing: IconButton(
                            onPressed: () {
                              deleteDialog(index);
                            },
                            icon: Icon(
                              Icons.delete,
                            ),
                            
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    //!Delete token
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Get.offNamed('/login');
  }
}
