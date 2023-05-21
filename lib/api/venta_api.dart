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
}