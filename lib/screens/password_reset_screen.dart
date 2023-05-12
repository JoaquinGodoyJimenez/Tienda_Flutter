import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image.asset('assets/images/logo_itc.png', width: 120,)),
                  const SizedBox(height: 25,),
                  Text(
                    "Cambiar contraseña.", 
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 40,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "Ingresa el correo que deseas recuperar su contraseña.", 
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 15,
                      )
                    )
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor escriba su correo';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Por favor escriba un correo válido';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Correo electrónico',
                        focusColor: Colors.green,                
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      final email = _emailController.value.text.trim();
                      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: const Text('Correo enviado',),
                          content: const Text('Se le ha enviado un correo para cambiar la contraseña.', textAlign: TextAlign.justify,),
                          actions: [
                            TextButton(
                              onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: const Text('Aceptar')
                          )
                          ],
                        ),
                      );
                    }, 
                    icon: const Icon(Icons.email), 
                    label: const Text('Enviar correo')
                  )
                ],
              )
            ),
          ),
        )
      ),
    );
  }
}