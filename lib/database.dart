import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userID;
  DatabaseService(this.userID);

  final CollectionReference userTodos =
      FirebaseFirestore.instance.collection('userTodos');

  Query query =
      FirebaseFirestore.instance.collection('userTodos').orderBy("idNumber");

  Future setTodo(String item, bool value) async {
    return await userTodos
        .doc(userID)
        .set({item: value}, SetOptions(merge: true));
  }

  Future deleteTodo(String key) async {
    return await userTodos.doc(userID).update({
      key: FieldValue.delete(),
    });
  }

  Future checkIfUserExist() async {
    if ((await userTodos.doc(userID).get()).exists) {
      return true;
    } else {
      return false;
    }
  }

  Stream getTodos() {
    return userTodos.doc(userID).snapshots();
  }
}
