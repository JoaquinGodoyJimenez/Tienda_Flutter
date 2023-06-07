import 'package:dio/dio.dart';
import '../models/marca_model.dart';

class MarcaApi {
  final dio = Dio();
  
  Future<List<MarcaModel>?> getMarcas() async {
    try {
      final response = await dio.get('https://mrjc-tienda.000webhostapp.com/ws/marca_ws.php');
      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;
        return jsonData.map((marca) => MarcaModel.fromJson(marca)).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }
  
  Future<void> deleteMarca(int id) async {
    try {
      final url = 'https://mrjc-tienda.000webhostapp.com/ws/marca_ws.php?id=$id';
      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        print('Marca eliminada con éxito');
      } else {
        print('Error al eliminar la marca. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al eliminar la marca: $e');
    }
  }
}