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
}