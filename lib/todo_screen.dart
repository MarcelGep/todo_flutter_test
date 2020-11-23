import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter_test/login_screen2.dart';
import 'authentication_service.dart';
import 'add_item_dialog.dart';
import 'database.dart';
import 'todo_item.dart';

class ToDoScreen extends StatefulWidget {
  final String userId;
  const ToDoScreen({Key key, this.userId}) : super(key: key);

  @override
  _ToDoScreenState createState() {
    return _ToDoScreenState();
  }
}

class _ToDoScreenState extends State<ToDoScreen> {
  Future myFuture;
  DatabaseService database;

  void sortItems() {}

  void addItem(String key) {
    database.setTodo(key, false);
  }

  void deleteItem(String key) {
    database.deleteTodo(key);
  }

  void newEntry() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AddItemDialog(addItem);
        });
  }

  void toggleDone(String key, bool value) {
    database.setTodo(key, !value);
  }

  Future<void> _connectToFirebase() async {
    print('Connect to database with user id: ' + widget.userId);
    database = DatabaseService(widget.userId);
    if (!(await database.checkIfUserExist())) {
      database.setTodo('Erstes ToDo Item', false);
      print('Neuer User wurde angelegt: ' + widget.userId);
    }
  }

  @override
  void initState() {
    myFuture = _connectToFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo Flutter'),
        backgroundColor: Color.fromRGBO(35, 152, 185, 100),
      ),
      body: FutureBuilder(
          future: myFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return StreamBuilder<DocumentSnapshot>(
                  stream: database.getTodos(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      Map<String, dynamic> items = snapshot.data.data();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, i) {
                                  String key = items.keys.elementAt(i);
                                  return ToDoItem(
                                    key,
                                    items[key],
                                    () => deleteItem(key),
                                    () => toggleDone(key, items[key]),
                                  );
                                }),
                          ),
                          RaisedButton(
                            onPressed: () {
                              context.read<AuthenticationService>().signOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                            },
                            child: Text("Sign out"),
                          ),
                          RaisedButton(
                            onPressed: sortItems,
                            child: Text("Sortieren"),
                          ),
                        ],
                      );
                    }
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: newEntry,
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(35, 152, 185, 100),
      ),
    );
  }
}
