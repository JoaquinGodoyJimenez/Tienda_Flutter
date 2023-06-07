import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/api/marca_api.dart';
import '../models/marca_model.dart';
import '../provider/font_provider.dart';

class MarcasScreen extends StatefulWidget {
  const MarcasScreen({Key? key}) : super(key: key);

  @override
  State<MarcasScreen> createState() => _MarcasScreenState();
}

class _MarcasScreenState extends State<MarcasScreen> {
  MarcaApi? marcaApi;

  @override
  void initState() {
    super.initState();
    marcaApi = MarcaApi();
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Marcas',
          style: TextStyle(fontFamily: font),
        ),
      ),
      body: FutureBuilder(
        future: marcaApi?.getMarcas(),
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
                    const DataColumn(label: Text('Marca')),
                    const DataColumn(label: Text('Proveedor')),
                    const DataColumn(label: Text('Opciones')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) {
                      final marca = snapshot.data![index];
                          
                      return DataRow(cells: [
                        DataCell(Text(
                          marca.idMarca,
                          style: TextStyle(fontFamily: font, color: Colors.blue.shade500),
                        )),
                        DataCell(Text(
                          marca.marca,
                          style: TextStyle(fontFamily: font),
                        )),
                        DataCell(Text(
                          marca.proveedor,
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
                                          Text('¿Desea editar la marca?'),
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
                                            Navigator.pushNamed(context, '/marcas');
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
                                          Text('¿Desea borrar la marca?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            marcaApi?.deleteMarca(int.parse(marca.idMarca));
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context, '/marcas');
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
                'No se encontraron marcas.',
                style: TextStyle(fontFamily: font),
              ),
            );
          }
        },
      ),
    );
  }
}
