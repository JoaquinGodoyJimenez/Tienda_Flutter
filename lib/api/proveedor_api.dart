import 'package:dio/dio.dart';
import '../models/proveedor_model.dart';

class ProveedorApi {
  final dio = Dio();

  Future<List<ProveedorModel>?> getProveedores() async {
    try {
      final response = await dio.get('https://mrjc-tienda.000webhostapp.com/ws/proveedor_ws.php');
      if (response.statusCode == 200) {
        print("Se consiguieron los datos con éxito");
        final jsonData = response.data as List<dynamic>;
        return jsonData.map((proveedor) => ProveedorModel.fromJson(proveedor)).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }
}