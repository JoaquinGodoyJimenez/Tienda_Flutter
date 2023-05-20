import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseCMSubscription {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

}