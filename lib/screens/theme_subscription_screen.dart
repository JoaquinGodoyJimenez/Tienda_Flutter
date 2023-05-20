import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/widgets/theme_suscription.dart';

import '../provider/font_provider.dart';

class ThemeSuscriptionScreen extends StatefulWidget {
  const ThemeSuscriptionScreen({super.key});

  @override
  State<ThemeSuscriptionScreen> createState() => _ThemeSuscriptionScreenState();
}

class _ThemeSuscriptionScreenState extends State<ThemeSuscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Suscripciones de temas",
          style: TextStyle(
            fontFamily: font
          ),
        ),
      ),
      body: const ThemeSuscription()
    );
  }
}