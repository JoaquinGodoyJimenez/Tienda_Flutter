import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/api/empleado_api.dart';
import '../models/empleado_model.dart';
import '../provider/font_provider.dart';

class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key});

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  EmpleadoApi? empleadoApi;

  @override
  void initState() {
    super.initState();
    empleadoApi = EmpleadoApi();
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Empleados',
          style: TextStyle(fontFamily: font),
        ),
      ),
      body: FutureBuilder(
        future: empleadoApi?.getEmpleados(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(width: 150, child: LinearProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ocurrió un error: ${snapshot.error}',
                style: TextStyle(fontFamily: font),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              child: Center(
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('ID')),
                    const DataColumn(label: Text('nombre')),
                    const DataColumn(label: Text('telefono')),
                    const DataColumn(label: Text('Opciones')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) {
                      final empleado = snapshot.data![index];
                          
                      return DataRow(cells: [
                        DataCell(Text(
                          empleado.idEmpleado,
                          style: TextStyle(fontFamily: font, color: Colors.blue.shade500),
                        )),
                        DataCell(Text(
                          empleado.nombre,
                          style: TextStyle(fontFamily: font),
                        )),
                        DataCell(Text(
                          empleado.telefono,
                          style: TextStyle(fontFamily: font),
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmar editar'),
                                      content:
                                          Text('¿Desea editar al empleado?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context, '/empleados');
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            print('Se ha editao');
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmar borrado'),
                                      content:
                                          Text('¿Desea borrar al empleado?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            empleadoApi?.deleteEmpleado(int.parse(empleado.idEmpleado));
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context, '/empleados');
                                          },
                                          child: const Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        )),
                      ]);
                    },
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'No se encontraron empleados.',
                style: TextStyle(fontFamily: font),
              ),
            );
          }
        },
      ),
    );
  }
}
