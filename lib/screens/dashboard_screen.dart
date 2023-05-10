import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
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
              onTap: () {
                Navigator.pushNamed(context, '/board');
              },
              title: const Text('Acerca de la institución'),
              subtitle: const Text('Conozca más detalles del ITC'),
              leading: const Icon(Icons.loupe),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/theme'),
              title: const Text('Configuración del tema'),
              subtitle: const Text('Cambie el tema de la app.'),
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/events');
              },
              title: const Text('Tareas y eventos'),
              subtitle: const Text('Calendario de eventos'),
              leading: const Icon(Icons.edit_calendar_rounded),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/api');
              },
              title: const Text('Lista de gatos'),
              subtitle: const Text('API de gatos'),
              leading: const Icon(Icons.favorite),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/popular'),
              title: const Text('Películas populares'),
              subtitle: const Text('Api de películas'),
              leading: const Icon(Icons.movie),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/favorites'),
              title: const Text('Peliculas favoritas'),
              leading: const Icon(Icons.star),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/maps'),
              title: const Text('Mapa'),
              leading: const Icon(Icons.map),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () async {
                await GoogleSignIn().signOut();
                await FacebookAuth.instance.logOut();
                await FirebaseGithubAuth().signOut();
                await _auth.signOut();
                Navigator.pushNamed(context, '/welcome');
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