import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tienda/routes.dart';
import 'package:tienda/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:tienda/provider/flags_provider.dart';
import 'package:tienda/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(context)),
        ChangeNotifierProvider(create: (_) => FlagsProvider())
      ],
      child: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getthemeData(),
      routes: getApplicationRoutes(),
      home: const WelcomeScreen(),
    );
  }
}
