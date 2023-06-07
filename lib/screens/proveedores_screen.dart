import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/api/proveedor_api.dart';
import '../models/proveedor_model.dart';
import '../provider/font_provider.dart';

class ProveedorScreen extends StatefulWidget {
  const ProveedorScreen({super.key});

  @override
  State<ProveedorScreen> createState() => _ProveedorScreenState();
}

class _ProveedorScreenState extends State<ProveedorScreen> {
  ProveedorApi? proveedorApi;

  @override
  void initState() {
    super.initState();
    proveedorApi = ProveedorApi();
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Proveedores',
          style: TextStyle(fontFamily: font),
        ),
      ),
      body: FutureBuilder(
        future: proveedorApi?.getProveedores(),
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
                    const DataColumn(label: Text('Proveedor')),
                    const DataColumn(label: Text('Teléfono')),
                    const DataColumn(label: Text('Opciones')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) {
                      final proveedor = snapshot.data![index];
                          
                      return DataRow(cells: [
                        DataCell(Text(
                          proveedor.idProveedor,
                          style: TextStyle(fontFamily: font, color: Colors.blue.shade500),
                        )),
                        DataCell(Text(
                          proveedor.proveedor,
                          style: TextStyle(fontFamily: font),
                        )),
                        DataCell(Text(
                          proveedor.telefono,
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
                                          Text('¿Desea editar el proveedor?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();                                            
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            print('Se ha editao');
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context, '/proveedores');
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
                                          Text('¿Desea borrar el proveedor?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            proveedorApi?.deleteProveedor(int.parse(proveedor.idProveedor));
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context, '/proveedores');
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
                'No se encontraron proveedores.',
                style: TextStyle(fontFamily: font),
              ),
            );
          }
        },
      ),
    );
  }
}
