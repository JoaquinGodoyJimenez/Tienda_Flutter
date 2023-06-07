import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/font_provider.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
    required String fontFamily
  }) =>
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(urlImage), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
                color: Colors.black.withOpacity(0.7), // Ajusta la opacidad según tus necesidades
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 64,),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Container(
                  padding: const EdgeInsets.symmetric(),
                  child: Center(
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: fontFamily,
                        fontSize: 20
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font =  fontProvider.selectedFontFamily;
    
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 50),
        child: PageView(
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          controller: controller,
          children: [
            buildPage(
              color: Colors.green.shade500, 
              urlImage: 'assets/images/page1.jpg', 
              title: 'Administra tu tienda', 
              subtitle: 'La aplicación te permite administrar la mayor parte\n de los datos de la tienda, como los proveedores,\n productos, marcas, etc.',
              fontFamily: font
            ),
            buildPage(
              color: Colors.blue.shade300, 
              urlImage: 'assets/images/page2.jpg', 
              title: 'Recibe notificaciones', 
              subtitle: 'La aplicación te permite suscribirte a variedad\n de temas, para recibir notificaciones útiles.',
              fontFamily: font
            ),
            buildPage(
              color: Colors.red.shade400, 
              urlImage: 'assets/images/page3.jpg', 
              title: 'Personaliza la aplicación', 
              subtitle: 'La aplicación te permite personalizar\n el color y el tipo de letra.',
              fontFamily: font
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
      ? TextButton(
        onPressed: () async {
          Navigator.popAndPushNamed(context, '/dash');
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.teal,
          minimumSize: const Size.fromHeight(50)
        ), 
        child: Text(
          'Iniciar',
          style: TextStyle(
            fontSize: 24,
            fontFamily: font,
            color: Colors.white
          ),
        ),
      )
      :
      Container(
        padding: const EdgeInsets.symmetric(horizontal:  10),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => controller.jumpToPage(2), 
              child: const Text('Skip')
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect:  const WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.lightBlue
                ), 
                onDotClicked: (index) => controller.animateToPage(
                  index, 
                  duration: const Duration(microseconds: 500), 
                  curve: Curves.easeIn
                ),
              )
            ),
            TextButton(
              onPressed: () => controller.nextPage(
                duration: const Duration(microseconds: 500), 
                curve: Curves.easeInOut
              ), 
              child: const Text('Next')
            )
          ],
        ),
      ),
    );
  }
}