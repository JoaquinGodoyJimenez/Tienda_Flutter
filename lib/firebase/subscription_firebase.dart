import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionFirebase {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _subscriptionCollection;

  SubscriptionFirebase(){
    _subscriptionCollection = _firebase.collection('subscriptions'); 
  }

  Future<void> insSubs(Map<String, dynamic> map) async{
    return _subscriptionCollection!.doc().set(map);
  }

  Future<void> updSub(Map<String,dynamic> map, String id) async{
    return _subscriptionCollection!.doc(id).update(map);
  }

  Future<void> delSub(String id) async{
    return _subscriptionCollection!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllSubs(){
    return _subscriptionCollection!.snapshots();
  } 

  Future<bool> checkThemeExists(String theme) async {
    final querySnapshot = await _subscriptionCollection!
        .where('theme', isEqualTo: theme)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> delSubByTheme(String theme) async {
    final querySnapshot = await _subscriptionCollection!
        .where('theme', isEqualTo: theme)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      return _subscriptionCollection!.doc(docId).delete();
    }
  }
}