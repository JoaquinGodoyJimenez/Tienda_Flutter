import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/firebase/firebase_github_auth.dart';
import 'package:tienda/firebase/user_firebase.dart';

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
    User? user = auth.currentUser;
    UserFirebase userFirebase = UserFirebase();
    String? userEmail = auth.currentUser?.email.toString() ?? '';
    String? userName = auth.currentUser?.displayName.toString();
    String? userPhoto = auth.currentUser?.photoURL.toString();
    final fontProvider = Provider.of<FontProvider>(context);
    late String font =  fontProvider.selectedFontFamily;
    
    if (userName == 'null') {
      userName = 'Usuario conectado:';
    }

    if (userPhoto == 'null') {
      userPhoto = 'https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png';
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tienda',
          style: TextStyle(
            fontFamily: font
          ),
        ),
      ),
      body: Text('Bienvenido', style: TextStyle(
        fontFamily: font
      )),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userPhoto!),
                backgroundColor: Colors.white,
              ),
              accountName:  Text(
                userName!,
                style: TextStyle(
                  fontFamily: font
                ),
              ), 
              accountEmail: Text(
                userEmail,
                style: TextStyle(
                  fontFamily: font
                ),
              )
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/theme'),
              title: Text(
                'Cambiar tema',
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
                'Cambiar tipo de letra',
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
  }
}