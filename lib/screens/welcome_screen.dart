import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15,),
                Center(child: Image.asset('assets/images/logo_itc.png', width: 120,)),
                const SizedBox(height: 25,),
                Text(
                  "Bienvenido.", 
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
                  "Inicie sesión o registre una cuenta", 
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                    )
                  )
                ),
                const SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),                  
                  ),
                  child: const Text("Iniciar Sesion")
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),                  
                  ),
                  child: const Text("Registrarse")
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}