import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/provider/font_provider.dart';
import 'package:tienda/provider/userphoto_provider.dart';
import 'package:tienda/routes.dart';
import 'package:tienda/screens/dashboard_screen.dart';
import 'package:tienda/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:tienda/provider/flags_provider.dart';
import 'package:tienda/provider/theme_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();  
  final _prefs = await SharedPreferences.getInstance();
  final _logged = _prefs.getBool('logged');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  String? token = await messaging.getToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  print('Token: $token');
  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp(logged: _logged ?? false));
}

class MyApp extends StatelessWidget {
  final bool logged;

  const MyApp({Key? key, required this.logged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(context)),
        ChangeNotifierProvider(create: (_) => FontProvider()),
        ChangeNotifierProvider(create: (_) => FlagsProvider()),
        ChangeNotifierProvider(create: (_) => UserPhotoProvider()),
      ],
      child: MyHomePage(logged: logged),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  final bool logged;
  const MyHomePage({Key? key, required this.logged}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getthemeData(),
      routes: getApplicationRoutes(),
      home: widget.logged == true ? const DashboardScreen() : const WelcomeScreen(),
    );
  }
}