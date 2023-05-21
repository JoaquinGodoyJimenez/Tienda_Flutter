import 'package:flutter/material.dart';
import 'package:tienda/screens/categories_screen.dart';
import 'package:tienda/screens/dashboard_screen.dart';
import 'package:tienda/screens/email_verification_screen.dart';
import 'package:tienda/screens/empleados_screen.dart';
import 'package:tienda/screens/font_configuration_screen.dart';
import 'package:tienda/screens/login_screen.dart';
import 'package:tienda/screens/marcas_screen.dart';
import 'package:tienda/screens/onboard_screen.dart';
import 'package:tienda/screens/password_reset_screen.dart';
import 'package:tienda/screens/proveedores_screen.dart';
import 'package:tienda/screens/register_screen.dart';
import 'package:tienda/screens/theme_configuration_screen.dart';
import 'package:tienda/screens/theme_subscription_screen.dart';
import 'package:tienda/screens/ventas_screen.dart';
import 'package:tienda/screens/welcome_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/verification': (BuildContext context) => const EmailVerificationScreen(),
    '/resetpassword': (BuildContext context) => const PasswordResetScreen(),  
    '/dash': (BuildContext context) => const DashboardScreen(), 
    '/welcome': (BuildContext context) => const WelcomeScreen(),
    '/theme': (BuildContext context) => const ThemeConfigurationScreen(), 
    '/font': (BuildContext context) => const FontConfigurationScreen(), 
    '/onboard': (BuildContext context) => const OnboardScreen(), 
    '/suscription': (BuildContext context) => const ThemeSuscriptionScreen(), 
    '/categories': (BuildContext context) => const CategoriesScreen(),
    '/proveedores': (BuildContext context) => const ProveedorScreen(),
    '/marcas': (BuildContext context) => const MarcasScreen(),
    '/ventas': (BuildContext context) => const VentasScreen(),
    '/empleados': (BuildContext context) => const EmpleadosScreen(),
  };
}