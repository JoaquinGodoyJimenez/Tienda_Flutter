import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/provider/font_provider.dart';

import '../provider/theme_provider.dart';
import '../settings/styles_settings.dart';

class ThemeConfigurationScreen extends StatefulWidget {
  const ThemeConfigurationScreen({super.key});

  @override
  State<ThemeConfigurationScreen> createState() => _ThemeConfigurationScreenState();
}

class _ThemeConfigurationScreenState extends State<ThemeConfigurationScreen> {
  late ThemeProvider theme;

  @override
  void initState() {
    super.initState();
    theme = Provider.of<ThemeProvider>(context, listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
  final fontProvider = Provider.of<FontProvider>(context);
  late String font =  fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selector de tema',
          style: TextStyle(
            fontFamily: font
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.lightTheme(context), 'lightTheme');
                    }, 
                    icon: const Icon(Icons.sunny), 
                    label: Text('Verde día', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                  const SizedBox(width: 35,),
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.darkTheme(context), 'darkTheme');
                    }, 
                    icon: const Icon(Icons.nightlight), 
                    label: Text('Verde noche', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade900,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.lightBlueTheme(context), 'lightBlueTheme');
                    }, 
                    icon: const Icon(Icons.sunny), 
                    label: Text('Azul día', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                  const SizedBox(width: 35,),
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.darkBlueTheme(context), 'darkBlueTheme');
                    }, 
                    icon: const Icon(Icons.nightlight), 
                    label: Text('Azul noche', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.lightRedTheme(context), 'lightRedTheme');
                    }, 
                    icon: const Icon(Icons.sunny), 
                    label: Text('Rojo día', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                  const SizedBox(width: 35,),
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.darkRedTheme(context), 'darkRedTheme');
                    }, 
                    icon: const Icon(Icons.nightlight), 
                    label: Text('Rojo noche', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.lightPurpleTheme(context), 'lightPurpleTheme');
                    }, 
                    icon: const Icon(Icons.sunny), 
                    label: Text('Morado día', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                  const SizedBox(width: 35,),
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.darkPurpleTheme(context), 'darkPurpleTheme');
                    }, 
                    icon: const Icon(Icons.nightlight), 
                    label: Text('Morado noche', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade900,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.lightPinkTheme(context), 'lightPinkTheme');
                    }, 
                    icon: const Icon(Icons.sunny), 
                    label: Text('Rosa día', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                  const SizedBox(width: 35,),
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.darkPinkTheme(context), 'darkPinkTheme');
                    }, 
                    icon: const Icon(Icons.nightlight), 
                    label: Text('Rosa noche', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade900,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.lightOrangeTheme(context), 'lightOrangeTheme');
                    }, 
                    icon: const Icon(Icons.sunny), 
                    label: Text('Naranja día', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade300,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                  const SizedBox(width: 35,),
                  ElevatedButton.icon(
                    onPressed: () {
                      theme.setthemeData(StyleSettings.darkOrangeTheme(context), 'darkOrangeTheme');
                    }, 
                    icon: const Icon(Icons.nightlight), 
                    label: Text('Naranja noche', style: TextStyle(fontFamily: font)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade900,
                      minimumSize: const Size(150, 50)
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}