import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Driver {
  int? id;
  String licenseNumber;
  String ?licensePic;
  String? driverPic;
  String driverName;
  String? status;
  String ?phoneNumber;
  DateTime? birthDate;
  String? experience;
  String? licenseGrade;
  String? gender;
  DateTime ?licenseIssueDate;
  DateTime? licenseExpireDate;
  String? vehicleOwner;
  String? roles;
  String plateNumber;
  bool? statMessage;
  String? driverstate;
  dynamic? vehicleCondition;
  dynamic? vehicleCatagory;
  Driver({
   this.id,
    required this.licenseNumber,
   this.licensePic,
    this.driverPic,
    required this.driverName,
   this.status,
   this.phoneNumber,
   this.birthDate,
   this.experience,
   this.licenseGrade,
   this.gender,
   this.licenseIssueDate,
   this.licenseExpireDate,
   this.vehicleOwner,
   this.roles,
    required this.plateNumber,
   this.statMessage,
   this.driverstate,
   this.vehicleCondition,
   this.vehicleCatagory,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'licenseNumber': licenseNumber,
      'licensePic': licensePic,
      'driverPic': driverPic,
      'driverName': driverName,
      'status': status,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate!.millisecondsSinceEpoch,
      'experience': experience,
      'licenseGrade': licenseGrade,
      'gender': gender,
      'licenseIssueDate': licenseIssueDate!.millisecondsSinceEpoch,
      'licenseExpireDate': licenseExpireDate!.millisecondsSinceEpoch,
      'vehicleOwner': vehicleOwner,
      'roles': roles,
      'plateNumber': plateNumber,
      'statMessage': statMessage,
      'driverstate': driverstate,
      'vehicleCondition': vehicleCondition,
      'vehicleCatagory': vehicleCatagory,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as int,
      licenseNumber: map['licenseNumber'] as String,
      licensePic: map['licensePic'] as String,
      driverPic: map['driverPic'] as String,
      driverName: map['driverName'] as String,
      status: map['status'] as String,
      phoneNumber: map['phoneNumber'] as String,
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate'] as int),
      experience: map['experience'] as String,
      licenseGrade: map['licenseGrade'] as String,
      gender: map['gender'] as String,
      licenseIssueDate: DateTime.fromMillisecondsSinceEpoch(map['licenseIssueDate'] as int),
      licenseExpireDate: DateTime.fromMillisecondsSinceEpoch(map['licenseExpireDate'] as int),
      vehicleOwner: map['vehicleOwner'] as String,
      roles: map['roles'] as String,
      plateNumber: map['plateNumber'] as String,
      statMessage: map['statMessage'] as bool,
      driverstate: map['driverstate'] as String,
      vehicleCondition: map['vehicleCondition'] as dynamic,
      vehicleCatagory: map['vehicleCatagory'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory Driver.fromJson(String source) => Driver.fromMap(json.decode(source) as Map<String, dynamic>);
}
