import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/firebase/firebase_github_auth.dart';
import 'package:tienda/screens/user_details_screen.dart';

import '../firebase/user_firebase.dart';
import '../provider/font_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final UserFirebase userFirebase = UserFirebase();
    String? userEmail = auth.currentUser?.email.toString() ?? '';
    final fontProvider = Provider.of<FontProvider>(context);
    late String font =  fontProvider.selectedFontFamily;

    return StreamBuilder(
      stream: userFirebase.getUserByEmail(userEmail),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Bienvenido a la tienda',
                style: TextStyle(
                  fontFamily: font
                ),
              ),
            ),
            body: const UserDetailsScreen(),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.docs[0].get('photoURL')),
                      backgroundColor: Colors.white,
                    ),
                    accountName:  Text(
                      snapshot.data!.docs[0].get('name'),
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ), 
                    accountEmail: Text(
                      snapshot.data!.docs[0].get('email'),
                      style: TextStyle(
                        fontFamily: font
                      ),
                    )
                  ),
                  ListTile(
                    onTap: () async {
                      final _prefs = await SharedPreferences.getInstance();
                      await _prefs.setBool('seenBoard', true);
                      Navigator.pushNamed(context, '/onboard');
                    },
                    title: Text(
                      'Presentación',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    subtitle: Text(
                      'Detalles sobre la app.',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    leading: const Icon(Icons.search),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, '/theme'),
                    title: Text(
                      'Configuración de tema',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    subtitle: Text(
                      'Cambie el tema de la app.',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, '/font'),
                    title: Text(
                      'Configuración de tipo de letra',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    subtitle: Text(
                      'Cambie el tipo de letra.',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, '/suscription'),
                    title: Text(
                      'Configuración de suscripciones',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    subtitle: Text(
                      'Administre sus notificaciones.',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    onTap: () async {
                      await GoogleSignIn().signOut();
                      await FacebookAuth.instance.logOut();
                      await FirebaseGithubAuth().signOut();
                      await auth.signOut();
                      final _prefs = await SharedPreferences.getInstance();
                      await _prefs.setBool('logged', false);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/welcome');
                    },
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    subtitle: Text(
                      'Regresar al inicio.',
                      style: TextStyle(
                        fontFamily: font
                      ),
                    ),
                    leading: const Icon(Icons.exit_to_app),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          );
        }else if (snapshot.hasError) {
          return const Center(
            child: Text('Error en la petición, Intente de nuevo.'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}