import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letterbook/models/diario_model.dart';

class DiarioService {
  final CollectionReference _diarioCollection =
      FirebaseFirestore.instance.collection('diarios');
  
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> adicionarDiario(String title, String description, DateTime date) async {
    final diario = Diario(
      title: title,
      description: description,
      date: date,
      userId: userId, // Associa o diário ao ID do usuário
    );
    await _diarioCollection.add(diario.toMap());
  }

  Future<void> atualizarDiario(String id, String title, String description, DateTime date) async {
    final diario = Diario(
      title: title,
      description: description,
      date: date,
      userId: userId,
    );
    await _diarioCollection.doc(id).update(diario.toMap());
  }

  Future<void> deleteDiario(String id) async {
    await _diarioCollection.doc(id).delete();
  }

  Stream<List<Diario>> getDiarios() {
    // Busca apenas os diários associados ao usuário atual
    return _diarioCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Diario.fromMap(data, doc.id);
      }).toList();
    });
  }
}
