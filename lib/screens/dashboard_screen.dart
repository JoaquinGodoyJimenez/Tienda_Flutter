import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/firebase/firebase_github_auth.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
      ),
      body:  const Text('Bienvenido'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushNamed(context, '/add').then((value) {
            setState(() {});
          });
        },
        label: const Text('Add post!'),
        icon: const Icon(Icons.add_comment),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? 'https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png'),
              ),
              accountName:  Text(user?.displayName.toString() ?? 'Usuario conectado'), 
              accountEmail: Text(user?.email.toString() ?? 'Error al recuperar el correo.')
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/theme'),
              title: const Text('Configuración del tema'),
              subtitle: const Text('Cambie el tema de la app.'),
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () async {
                await GoogleSignIn().signOut();
                await FacebookAuth.instance.logOut();
                await FirebaseGithubAuth().signOut();
                await _auth.signOut();
                final _prefs = await SharedPreferences.getInstance();
                await _prefs.setBool('logged', false);
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/welcome');
              },
              title: const Text('Cerrar Sesión'),
              subtitle: const Text('Regresar a la pantalla de inicio.'),
              leading: const Icon(Icons.exit_to_app),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}