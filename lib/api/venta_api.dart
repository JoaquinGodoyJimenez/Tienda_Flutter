import 'package:dio/dio.dart';
import '../models/venta_model.dart';

class VentaApi {
  final dio = Dio();
  
  Future<List<VentaModel>?> getVentas() async {
    try {
      final response = await dio.get('https://mrjc-tienda.000webhostapp.com/ws/venta_ws.php');
      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;
        return jsonData.map((venta) => VentaModel.fromJson(venta)).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  Future<void> deleteVenta(int id) async {
    try {
      final url = 'https://mrjc-tienda.000webhostapp.com/ws/venta_ws.php?id=$id';
      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        print('Venta eliminada con éxito');
      } else {
        print('Error al eliminar la venta. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al eliminar la venta: $e');
    }
  }
}