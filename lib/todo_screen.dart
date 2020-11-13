import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'add_item_dialog.dart';
import 'database.dart';
import 'todo_item.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  User currentUser;
  DatabaseService database;

  void addItem(String key) {
    database.setTodo(key, false);
    Navigator.pop(context);
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

  Future<void> connectToFirebase() async {
    print('Connect to database with user id: ' + currentUser.uid);
    database = DatabaseService(currentUser.uid);
    if (!(await database.checkIfUserExist())) {
      database.setTodo('Erstes ToDo Item', false);
      print('Neuer User wurde angelegt: ' + currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo Flutter'),
        backgroundColor: Color.fromRGBO(35, 152, 185, 100),
      ),
      body: FutureBuilder(
          future: connectToFirebase(),
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
                            onPressed:
                                context.watch<AuthenticationService>().signOut,
                            child: Text("Sign out"),
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
