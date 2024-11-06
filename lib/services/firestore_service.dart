
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference tasks =
    FirebaseFirestore.instance.collection("tasks");

  Future addTask(String title, String description) {
    return tasks.add({
      "title": title,
      "description": description,
    });
  }
}