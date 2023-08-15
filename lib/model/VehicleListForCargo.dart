import 'dart:convert';

class Cargo_Vehicle {
  final int id;
  final String driver;
  final String cargo;
  final String vehicleOwner;
  final String plateNumber;
  final int driverID;
  final String driverState;
  Cargo_Vehicle({
    required this.id,
    required this.driver,
    required this.cargo,
    required this.vehicleOwner,
    required this.plateNumber,
    required this.driverID,
    required this.driverState,
  });

  factory Cargo_Vehicle.fromJson(Map<String, dynamic> json) {
    return Cargo_Vehicle(
      id: json['id'],
      driver: json['driver'],
      cargo: json['cargo'],
      vehicleOwner: json['vehicleOwner'],
      plateNumber: json['plateNumber'],
      driverID: json['driverID'],
       driverState: json['driverState'],
    );
  }
}
