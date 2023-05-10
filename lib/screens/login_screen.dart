import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tienda/firebase/firebase_auth.dart';
import 'package:tienda/firebase/firebase_google_auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../firebase/firebase_facebook_auth.dart';
import '../firebase/firebase_github_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    EmailAuth emailAuth = EmailAuth();
    final formKey = GlobalKey<FormState>();
    bool login = false;

    handleSubmit() async {
    if (!formKey.currentState!.validate()) return;
    final email = emailController.value.text.trim();
    final password = passwordController.value.text.trim();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.popAndPushNamed(context, '/dash');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
    }
  }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15,),
                  Center(child: Image.asset('assets/images/logo_itc.png', width: 120,)),
                  const SizedBox(height: 25,),
                  Text(
                    "Iniciar sesión.", 
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 50,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "Que bueno que hayas regresado.", 
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 18,
                      )
                    )
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: emailController,
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
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor escriba su contraseña';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Contraseña',
                        focusColor: Colors.green,                
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () => handleSubmit(), 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),                  
                    ),
                    child: const Text("Iniciar Sesión")
                  ),
                  const SizedBox(height: 20,),
                  Row(                   
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.google, 
                        borderRadius: 20,
                        mode: SocialLoginButtonMode.single,
                        text: '',
                        onPressed: () async {
                          try {
                            await FireBaseGoogleAuth().signInWithGoogle();
                            Navigator.popAndPushNamed(context, '/dash');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
                          }                                   
                        },                      
                      ),
                      const SizedBox(width: 15,),
                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.facebook, 
                        borderRadius: 20,
                        mode: SocialLoginButtonMode.single,
                        text: '',
                        onPressed: () async {  
                          try {
                            await FirebaseFacebookAuth().signInWithFacebook();
                            Navigator.popAndPushNamed(context, '/dash');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
                          }   
                        },                      
                      ),
                      const SizedBox(width: 15,),
                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.github, 
                        borderRadius: 20,
                        mode: SocialLoginButtonMode.single,
                        text: '',
                        onPressed: () async {  
                          try {
                            await FirebaseGithubAuth().gitHubSign(context);
                            Navigator.popAndPushNamed(context, '/dash');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
                          }
                        },                      
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}