// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseGoogleAuth {
  final BuildContext context;
  bool register = false;
  FireBaseGoogleAuth(this.context);
  
  signInWithGoogle() async {
    //Begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //Obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //Create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(gUser.email);
    if (signInMethods.contains('password')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se puede ingresar con Google. Este usuario ya se encuentra registrado con Correo y contraseña.')));
      return null;
    } else if (signInMethods.contains('google.com')) {
      register = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ingresando. Espere un momento por favor.')));
    } else if (signInMethods.contains('facebook.com')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se puede ingresar con Google. Este usuario ya se encuentra registrado con Facebook.')));
      return null;
    } else if (signInMethods.contains('github.com')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se puede ingresar con Google. Este usuario ya se encuentra registrado con Github.')));
      return null;
    }
    else {
      register = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ingresando. Espere un momento por favor.')));
    }

    if (register) {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }    
  }
}