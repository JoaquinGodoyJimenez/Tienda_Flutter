import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/provider/font_provider.dart';
import 'package:tienda/provider/userphoto_provider.dart';
import 'package:tienda/routes.dart';
import 'package:tienda/screens/dashboard_screen.dart';
import 'package:tienda/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:tienda/provider/flags_provider.dart';
import 'package:tienda/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _prefs = await SharedPreferences.getInstance();
  final _logged = _prefs.getBool('logged');
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
