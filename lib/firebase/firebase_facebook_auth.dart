import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FacebookAuth _facebookAuth = FacebookAuth.instance;

class FirebaseFacebookAuth {
  signInWithFacebook() async{
    final LoginResult result = await _facebookAuth.login();

    // Verificar si el inicio de sesión fue exitoso
    if (result.status == LoginStatus.success) {
      // Obtener las credenciales de autenticación de Facebook
      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      // Iniciar sesión con las credenciales de Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } else {
      // Manejar el error de inicio de sesión
      throw FirebaseAuthException(message: 'Error al iniciar sesión con Facebook', code: '');
    }
  }
}
