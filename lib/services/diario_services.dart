import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letterbook/models/diario_model.dart';

class DiarioService {
  final CollectionReference _diarioCollection =
      FirebaseFirestore.instance.collection('diarios');

  Future<void> saveDiario(String title, String description, DateTime date) async {
    final diario = Diario(title: title, description: description, date: date);
    await _diarioCollection.add(diario.toMap());
  }


  Future<void> editDiario(String id, String title, String description, DateTime date) async {
    final diario = Diario(title: title, description: description, date: date);
    await _diarioCollection.doc(id).update(diario.toMap());
  }

  Future<void> deleteDiario(String id) async {
    await _diarioCollection.doc(id).delete();
  }

  Stream<List<Diario>> getDiarios() {
  return _diarioCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Diario.fromMap(data, doc.id);
    }).toList();
  });
}

}