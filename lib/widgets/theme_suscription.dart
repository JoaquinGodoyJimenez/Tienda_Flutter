import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/firebase/firebase_cm_subscription.dart';
import '../firebase/subscription_firebase.dart';
import '../provider/font_provider.dart';

class ThemeSuscription extends StatefulWidget {
  const ThemeSuscription({super.key});

  @override
  State<ThemeSuscription> createState() => _ThemeSuscriptionState();
}

class _ThemeSuscriptionState extends State<ThemeSuscription> {
  SubscriptionFirebase SubFirebase = SubscriptionFirebase();
  FirebaseCMSubscription fcmSusbcription = FirebaseCMSubscription();

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    Future<void> showEntregasDialog(BuildContext context, String theme) async {
      final themeExists = await SubFirebase.checkThemeExists(theme);

      if (themeExists) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cancelar suscripción de $theme'),
              content: Text('Ya está suscrito a $theme. ¿Desea cancelar la suscripción?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    fcmSusbcription.unsubscribeFromTopic(theme);
                    SubFirebase.delSubByTheme(theme);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }else{
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Añadir suscripción a $theme'),
              content: Text('¿Desea suscribirse a $theme?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    fcmSusbcription.subscribeToTopic(theme);
                    SubFirebase.insSubs({
                      'theme' : theme
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }

    return StreamBuilder(
      stream: SubFirebase.getAllSubs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Temas de notificaciones.",
                  style: TextStyle(fontFamily: font, fontSize: 30),
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {showEntregasDialog(context, 'entregas');},
                      icon: const Icon(Icons.fire_truck_rounded),
                      label: const Text("Entregas"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(190, 140),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),                            
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {showEntregasDialog(context, 'ofertas');},
                      icon: const Icon(Icons.tag),
                      label: const Text("Ofertas"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        minimumSize: const Size(190, 140),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {showEntregasDialog(context, 'preventas');},
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Preventas"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(190, 140),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {showEntregasDialog(context, 'recordatorios');},
                      icon: const Icon(Icons.alarm),
                      label: const Text("Recordatorios"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        minimumSize: const Size(190, 140),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error en la petición, Intente de nuevo.'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
