import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/firebase/firebase_google_auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tienda/firebase/user_firebase.dart';

import '../firebase/firebase_facebook_auth.dart';
import '../firebase/firebase_github_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    UserFirebase _firebase = UserFirebase();
    final FirebaseAuth _auth = FirebaseAuth.instance;


    handleSubmit() async {
    if (!formKey.currentState!.validate()) return;
    final email = emailController.value.text.trim();
    final password = passwordController.value.text.trim();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        final _prefs = await SharedPreferences.getInstance();
        await _prefs.setBool('logged', true);
        Navigator.popAndPushNamed(context, '/dash');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('No has verificado tu correo')));
        Navigator.popAndPushNamed(context, '/verification');
      }
      setState(() {
        isLoading = false;
      });        
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });     
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
      body: isLoading
      ? 
      const Center(
        child: SizedBox(width: 200,child: LinearProgressIndicator()),
      )
      :
      SafeArea(
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
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      handleSubmit();
                    } , 
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
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await FireBaseGoogleAuth(context).signInWithGoogle();
                            User? user = _auth.currentUser;
                            String email = user?.email.toString() ?? '';
                            String name = user?.displayName.toString() ?? '';
                            String? proveedor =  await _firebase.getUserProvider(email);
                            if (proveedor == null && email != '') {
                              _firebase.insUser({
                                'email' : email,
                                'name' : name,
                                'provider' : 'Google',
                              });
                              proveedor =  await _firebase.getUserProvider(email);
                            }
                            if (proveedor == 'Google') {
                              final _prefs = await SharedPreferences.getInstance();
                              await _prefs.setBool('logged', true);
                              Navigator.popAndPushNamed(context, '/dash');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
                            }else{
                              await GoogleSignIn().signOut();
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
                          }finally{
                            setState(() {
                              isLoading = false;
                            }); 
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
                          setState(() {
                            isLoading = true;
                          }); 
                          try {
                            await FirebaseFacebookAuth(context).signInWithFacebook();
                            User? user = _auth.currentUser;
                            String email = user?.email.toString() ?? '';
                            String name = user?.displayName.toString() ?? '';
                            String? proveedor =  await _firebase.getUserProvider(email); 
                            if (proveedor == null && email != '') {
                              _firebase.insUser({
                                'email' : email,
                                'name' : name,
                                'provider' : 'Facebook',
                              });
                              proveedor =  await _firebase.getUserProvider(email);
                            }     
                            if (proveedor == 'Facebook') {
                              final _prefs = await SharedPreferences.getInstance();
                              await _prefs.setBool('logged', true);
                              Navigator.popAndPushNamed(context, '/dash');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
                            }else{
                              await FirebaseGithubAuth().signOut();
                              await _auth.signOut();
                            }                                                  
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
                          } finally{
                            setState(() {
                              isLoading = false;
                            }); 
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
                          setState(() {
                              isLoading = true;
                          }); 
                          try {
                            await FirebaseGithubAuth().gitHubSign(context);
                            User? user = _auth.currentUser;
                            String email = user?.email.toString() ?? '';
                            String name = user?.displayName.toString() ?? '';
                            String? proveedor =  await _firebase.getUserProvider(email); 
                            if (proveedor == null && email != '') {
                              _firebase.insUser({
                                'email' : email,
                                'name' : name,
                                'provider' : 'Github',
                              });
                              proveedor =  await _firebase.getUserProvider(email);
                            } 
                            if (proveedor == 'Github') {
                              final _prefs = await SharedPreferences.getInstance();
                              await _prefs.setBool('logged', true);
                              Navigator.popAndPushNamed(context, '/dash');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ha iniciado sesión de manera correcta')));
                            }else{
                              await FacebookAuth.instance.logOut();
                            }   
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
                          }finally{
                            setState(() {
                              isLoading = false;
                            }); 
                          }  
                        },                      
                      ),
                    ],
                  ),
                  const SizedBox(width: 15,),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/resetpassword');
                    }, 
                    child: Text(
                      'Olvidé la contraseña', 
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline
                        )
                      ),
                    )
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