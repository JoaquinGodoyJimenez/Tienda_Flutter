import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tienda/firebase/user_firebase.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserFirebase _firebase = UserFirebase();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    handleSubmit() async {
      if (!_formKey.currentState!.validate()) return;
      final email = _emailController.value.text.trim();
      final password = _passwordController.value.text.trim();
      final name = _nameController.value.text.trim();
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
        await _firebase.insUser({
          'email' : email,
          'name' : name,
          'provider' : 'Email',
          'photoURL' : 'https://firebasestorage.googleapis.com/v0/b/mrjc-tienda.appspot.com/o/assets%2Fdefault_image.png?alt=media&token=32836d48-26bc-4a7b-9278-d7d020d47f3a', 
        }).then((value) => Navigator.popAndPushNamed(context, '/verification'));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Registrar usuario.'),
        centerTitle: true,
      ),
      body: _isLoading
      ? 
      const Center(
        child: SizedBox(width: 200,child: LinearProgressIndicator()),
      )
      :
      SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15,),
                  Center(child: Image.asset('assets/images/shopping_cart.png', width: 100,)),
                  const SizedBox(height: 25,),
                  Text(
                    "Registrarse.", 
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
                    "Comencemos ingresando tus datos.", 
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
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor escriba su nombre';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nombre completo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor escriba su contraseña';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Contraseña',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () => handleSubmit(), 
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),                  
                    ),
                    child: const Text("Registrarse")
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}