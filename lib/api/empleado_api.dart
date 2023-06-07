import 'package:dio/dio.dart';
import '../models/empleado_model.dart';

class EmpleadoApi {
  final dio = Dio();
  
  Future<List<EmpleadoModel>?> getEmpleados() async {
    try {
      final response = await dio.get('https://mrjc-tienda.000webhostapp.com/ws/empleado_ws.php');
      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;
        return jsonData.map((empleado) => EmpleadoModel.fromJson(empleado)).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  Future<void> deleteEmpleado(int id) async {
    try {
      final url = 'https://mrjc-tienda.000webhostapp.com/ws/empleado_ws.php?id=$id';
      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        print('Empleado eliminado con éxito');
      } else {
        print('Error al eliminar el empleado. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al eliminar el empleado: $e');
    }
  }
}