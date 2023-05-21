class VentaModel {
  String? idVenta;
  String? fecha;
  String? username;
  String? nombre;
  String? correo;
  String? direccion;
  String? telefono;

  VentaModel({
    this.idVenta, 
    this.fecha, 
    this.username, 
    this.nombre, 
    this.correo, 
    this.direccion, 
    this.telefono
  });

  factory VentaModel.fromJson(Map<String, dynamic> json) {
    return VentaModel(
      idVenta: json['id_venta'],
      fecha: json['fecha'],
      username: json['username'],
      nombre: json['nombre'],
      correo: json['correo'],
      direccion: json['direccion'],
      telefono: json['telefono'],
    );
  }
}
