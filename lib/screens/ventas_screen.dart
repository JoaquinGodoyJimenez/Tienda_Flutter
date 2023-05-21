import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/api/venta_api.dart';
import '../models/venta_model.dart';
import '../provider/font_provider.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  VentaApi? ventaApi;

  @override
  void initState() {
    super.initState();
    ventaApi = VentaApi();
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    late String font = fontProvider.selectedFontFamily;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ventas',
          style: TextStyle(fontFamily: font),
        ),
      ),
      body: FutureBuilder(
        future: ventaApi?.getVentas(),
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
                    const DataColumn(label: Text('Fecha')),
                    const DataColumn(label: Text('Vendedor')),
                    const DataColumn(label: Text('Opciones')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) {
                      final venta = snapshot.data![index];
                          
                      return DataRow(cells: [
                        DataCell(Text(
                          venta.idVenta,
                          style: TextStyle(fontFamily: font, color: Colors.blue.shade500),
                        )),
                        DataCell(Text(
                          venta.fecha,
                          style: TextStyle(fontFamily: font),
                        )),
                        DataCell(Text(
                          venta.nombre,
                          style: TextStyle(fontFamily: font),
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {},
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
                'No se encontraron ventas.',
                style: TextStyle(fontFamily: font),
              ),
            );
          }
        },
      ),
    );
  }
}
