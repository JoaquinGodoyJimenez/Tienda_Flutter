import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda/firebase/user_firebase.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _btnEmailVerification = true;
  bool _btnNewEmail = true;
  UserFirebase _firebase = UserFirebase();

  void _newEmail() {
    if (_btnNewEmail) {
      FirebaseAuth.instance.currentUser?.sendEmailVerification();      
      setState(() {
        _btnNewEmail = false;
      });
      Timer(const Duration(seconds: 500), () {
        setState(() {
          _btnNewEmail = true;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Verificación correo'),
        centerTitle: true,
      ),
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15,),
                Center(child: Image.asset('assets/images/logo_itc.png', width: 120,)),
                const SizedBox(height: 25,),
                Text(
                  "Se ha enviado un correo de verificación.", 
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w500
                    )
                  )
                ),
                const SizedBox(height: 10,),
                Text(
                  "Revisa la bandeja de entrada del correo.", 
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                    )
                  )
                ),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/login');
                  }, 
                  icon: const Icon(Icons.mark_email_read), 
                  label: const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _btnEmailVerification ? Colors.blue : Colors.grey, // Cambia el color del botón si está deshabilitado
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ya has verificado tu correo, presiona el botón de arriba.')));
                    }else{
                      _newEmail();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Se enviará un correo de verificación. Tendrás que esperar 5 minutos para mandar otro')));
                    }                    
                  }, 
                  icon: const Icon(Icons.email), 
                  label: const Text('Reenviar correo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _btnNewEmail ? Colors.blue : Colors.grey, // Cambia el color del botón si está deshabilitado
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}