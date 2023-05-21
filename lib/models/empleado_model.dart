class EmpleadoModel {
  String? idEmpleado;
  String? nombre;
  String? direccion;
  String? telefono;
  String? tienda;

  EmpleadoModel({this.idEmpleado, this.nombre, this.direccion, this.telefono, this.tienda});

  factory EmpleadoModel.fromJson(Map<String, dynamic> json) {
    return EmpleadoModel(
      idEmpleado: json['id_empleado'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      tienda: json['tienda'],
    );
  }
}
