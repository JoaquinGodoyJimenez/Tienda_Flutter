import 'package:flutter/material.dart';
import 'package:tienda/screens/dashboard_screen.dart';
import 'package:tienda/screens/login_screen.dart';
import 'package:tienda/screens/register_screen.dart';
import 'package:tienda/screens/theme_configuration_screen.dart';
import 'package:tienda/screens/welcome_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/dash': (BuildContext context) => const DashboardScreen(), 
    '/welcome': (BuildContext context) => const WelcomeScreen(),
    '/theme': (BuildContext context) => const ThemeConfigurationScreen(), 
  };
}