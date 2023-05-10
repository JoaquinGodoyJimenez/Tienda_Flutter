import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector de tema'),
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
                    label: const Text('Tema claro'),
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
                    label: const Text('Tema oscuro'),
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
                    label: const Text('Azul día'),
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
                    label: const Text('Azul noche'),
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
                    label: const Text('Rojo día'),
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
                    label: const Text('Rojo noche'),
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
                    label: const Text('Morado día'),
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
                    label: const Text('Morado noche'),
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
                    label: const Text('Rosa día'),
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
                    label: const Text('Rosa noche'),
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
                    label: const Text('Naranja día'),
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
                    label: const Text('Naranja noche'),
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