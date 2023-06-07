import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/api/categoria_api.dart';
import '../models/categoria_model.dart';
import '../provider/font_provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoriaApi? categoriaApi;

  @override
  void initState() {
    super.initState();
    categoriaApi = CategoriaApi();
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Categorias',
          style: TextStyle(fontFamily: font),
        ),
      ),
      body: FutureBuilder(
        future: categoriaApi?.getCategorias(),
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
                    const DataColumn(label: Text('Categoria')),
                    const DataColumn(label: Text('Opciones')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) {
                      final categoria = snapshot.data![index];

                      return DataRow(cells: [
                        DataCell(Text(
                          categoria.idCategoria,
                          style: TextStyle(
                              fontFamily: font, color: Colors.blue.shade500),
                        )),
                        DataCell(Text(
                          categoria.categoria,
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
                                          Text('¿Desea editar la categoria?'),
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
                                            Navigator.pushNamed(context, '/categories');
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
                                          Text('¿Desea borrar la categoria?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            categoriaApi?.deleteCategoria(int.parse(categoria.idCategoria));
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context, '/categories');
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
                'No se encontraron categorías.',
                style: TextStyle(fontFamily: font),
              ),
            );
          }
        },
      ),
    );
  }
}
