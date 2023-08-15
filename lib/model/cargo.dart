class Cargo {
  int id;
  String pickUp;
  String dropOff;
  String date;
  String cargoType;
  String cargoOwner;
  String packaging;
  String weight;
  String status;

  Cargo({
    required this.id,
    required this.pickUp,
    required this.dropOff,
    required this.date,
    required this.cargoType,
    required this.cargoOwner,
    required this.packaging,
    required this.weight,
    required this.status,
  });

  factory Cargo.fromJson(Map json) {
    return Cargo(
      id: json['id'],
      pickUp: json['pickUp'],
      dropOff: json['dropOff'],
      date: json['date'],
      cargoType: json['cargoType'],
      cargoOwner: json['cargoOwner'],
      packaging: json['packaging'],
      weight: json['weight'],
      status: json['status'],
    );
  }
}