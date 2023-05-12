import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseFacebookAuth {
  final BuildContext context;
  bool register = false;
  FirebaseFacebookAuth(this.context);

  signInWithFacebook() async {
    // Comenzar el proceso de inicio de sesión interactivo
    final LoginResult result = await FacebookAuth.instance.login();

    // Verificar si el inicio de sesión fue exitoso
    if (result.status == LoginStatus.success) {
      // Obtener las credenciales de autenticación de Facebook
      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);

      // Obtener información del perfil del usuario
      final userData = await FacebookAuth.instance
          .getUserData(fields: "email, first_name, last_name, picture");

      // Verificar si el usuario ya se ha registrado en Firebase
      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(userData['email']);
      if (signInMethods.contains('password')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No se puede ingresar con Facebook. Este usuario ya se encuentra registrado con Correo y contraseña.')));
        return null;
      } else if (signInMethods.contains('google.com')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No se puede ingresar con Facebook. Este usuario ya se encuentra registrado con Google.')));
        return null;
      } else if (signInMethods.contains('facebook.com')) {
        register = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ingresando. Espere un momento por favor.')));
      } else {
        register = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ingresando. Espere un momento por favor.')));
      }

      if (register) {
        // Iniciar sesión con las credenciales de Firebase
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } else {
      // Manejar el error de inicio de sesión
      throw FirebaseAuthException(
          message: 'Error al iniciar sesión con Facebook', code: '');
    }
  }
}
