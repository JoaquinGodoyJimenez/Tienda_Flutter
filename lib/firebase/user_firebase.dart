import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _userCollection;

  UserFirebase(){
    _userCollection = _firebase.collection('users'); 
  }

  Future<void> insUser(Map<String, dynamic> map) async{
    return _userCollection!.doc().set(map);
  }

  Future<void> updUser(Map<String,dynamic> map, String id) async{
    return _userCollection!.doc(id).update(map);
  }

  Future<void> delUser(String id) async{
    return _userCollection!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllUsers(){
    return _userCollection!.snapshots();
  } 

  Stream<QuerySnapshot> getUserByEmail(String email) {
    return _userCollection!.where('email', isEqualTo: email).snapshots();
  }
  
  Future<String?> getUserProvider(String email) async {
    try {
      final userDoc = await _userCollection!.where('email', isEqualTo: email).limit(1).get();
      if (userDoc.docs.isEmpty) {
        return null;
      }
      final provider = userDoc.docs[0]['provider'];
      return provider;
    } catch (e) {
      // handle the exception or error
      print(e);
      return null;
    }
  }

  Future<String?> getUserName(String email) async {
    try {
      final userDoc = await _userCollection!.where('email', isEqualTo: email).limit(1).get();
      if (userDoc.docs.isEmpty) {
        return null;
      }
      final provider = userDoc.docs[0]['name'];
      return provider;
    } catch (e) {
      // handle the exception or error
      print(e);
      return null;
    }
  }
}