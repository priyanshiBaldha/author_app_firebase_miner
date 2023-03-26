import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper{

  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchBookAuthorData() {
    return fireStore.collection('Author').snapshots();
  }

  Future<DocumentReference> insertBookAuthorData(
      {required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> documentReference = await fireStore
        .collection('Author').add(data);

    return documentReference;
  }

  Future<void> updateBookAuthorData(
      {required Map<String, dynamic> data, required String id}) async {
    await fireStore.collection('Author').doc(id).update(data);
  }

  Future<void> deleteBookAuthorData({required String id}) async {
    await fireStore.collection('Author').doc(id).delete();
  }



}