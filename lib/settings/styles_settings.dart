import 'package:flutter/material.dart';

class StyleSettings {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context)
        .colorScheme
        .copyWith(primary: const Color.fromARGB(255, 3, 90, 3)),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.green,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: const Color.fromARGB(255, 3, 90, 3)),
        iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.green,
      ),  
    );
  }

  static ThemeData lightBlueTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color.fromARGB(255, 28, 115, 197),
        ),
        iconTheme: theme.iconTheme.copyWith(
          size: 28,
          color: Colors.blue.shade900,
        )
    );
  }

  static ThemeData darkBlueTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: const Color.fromARGB(255, 28, 115, 197)),
        iconTheme: theme.iconTheme.copyWith(
          size: 28,
          color: Colors.blue,
        )
    );
  }

  static ThemeData lightRedTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary:  Colors.red, // un tono de púrpura personalizado
      ),
      iconTheme: theme.iconTheme.copyWith(
            size: 28,
            color: Colors.red,
      )
    );
  }

  static ThemeData darkRedTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary:  Colors.red, // un tono de púrpura personalizado
      ),
      iconTheme: theme.iconTheme.copyWith(
            size: 28,
            color: Colors.red,
      )
    );
  }

  static ThemeData lightPurpleTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 156, 39, 176),
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.deepPurple.shade900,
      ),
    );
  }

  static ThemeData darkPurpleTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 156, 39, 176),
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.deepPurple,
      ),
    );
  }

  static ThemeData lightPinkTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 233, 30, 99),
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.pink.shade900,
      ),
    );
  }

  static ThemeData darkPinkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 233, 30, 99),
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.pink,
      ),
    );
  }

  static ThemeData lightOrangeTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 255, 152, 0),
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.orange.shade900,
      ),
    );
  }

  static ThemeData darkOrangeTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 255, 152, 0),
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 28,
        color: Colors.orange,
      ),
    );
  }

}
