import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/provider/font_provider.dart';

class FontConfigurationScreen extends StatefulWidget {
  const FontConfigurationScreen({super.key});

  @override
  State<FontConfigurationScreen> createState() =>
      _FontConfigurationScreenState();
}

class _FontConfigurationScreenState extends State<FontConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font =  fontProvider.selectedFontFamily;
    final availableFonts = [
      'Default', 
      'Arial', 
      'Courier', 
      'Times', 
      'Cursive', 
      'Monospace', 
      'Montserrat', 
      'Lato', 
      'Merriweather', 
      'OpenSans', 
      'Oswald', 
      'Poppins', 
      'Raleway', 
      'Roboto', 
      'SourceSansPro', 
      'Ubuntu'
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Selector de fuente',
          style: TextStyle(fontFamily: font)
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Texto de ejemplo',
              style: TextStyle(
                fontFamily: fontProvider.selectedFontFamily,
                fontSize: 24,               
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableFonts.length,
              itemBuilder: (context, index) {
                final fontFamily = availableFonts[index];

                return ListTile(
                  title: Text(fontFamily),
                  onTap: () {
                    final fontProvider = Provider.of<FontProvider>(context, listen: false);
                    fontProvider.selectedFontFamily = fontFamily;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
