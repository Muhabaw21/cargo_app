import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CargoOwnerInfo {
  int id;
  String phoneNumber;
  String ownerName;
  String pic;
  bool enabled;
   BusinessInfo? businessInfo;
  Address? address;
  CargoOwnerInfo({
    required this.id,
    required this.phoneNumber,
    required this.ownerName,
    required this.pic,
    required this.enabled,
    required this.businessInfo,
    required this.address,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNumber': phoneNumber,
      'ownerName': ownerName,
      'pic': pic,
      'enabled': enabled,
      'businessInfo': businessInfo?.toMap(),
      'address': address?.toMap(),
    };
  }
  factory CargoOwnerInfo.fromMap(Map<String, dynamic> map) {
    return CargoOwnerInfo(
      id: map['id'] as int,
      phoneNumber: map['phoneNumber'] as String,
      ownerName: map['ownerName'] as String,
      pic: map['pic'] as String,
      enabled: map['enabled'] as bool,
      businessInfo: BusinessInfo.fromMap(map['businessInfo'] as Map<String,dynamic>),
      address: Address.fromMap(map['address'] as Map<String,dynamic>),
    );
  }
  String toJson() => json.encode(toMap());
  factory CargoOwnerInfo.fromJson(String source) => CargoOwnerInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
class BusinessInfo {
int id;
  String businessName;
  String businessSector;
  String businessType;
  String tinNumber;
  String licenseNumber;
  String license;
  String tin;
  BusinessInfo({
    required this.id,
    required this.businessName,
    required this.businessSector,
    required this.businessType,
    required this.tinNumber,
    required this.licenseNumber,
    required this.license,
    required this.tin,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'businessName': businessName,
      'businessSector': businessSector,
      'businessType': businessType,
      'tinNumber': tinNumber,
      'licenseNumber': licenseNumber,
      'license': license,
      'tin': tin,
    };
  }
  factory BusinessInfo.fromMap(Map<String, dynamic> map) {
    return BusinessInfo(
      id: map['id'] as int,
      businessName: map['businessName'] as String,
      businessSector: map['businessSector'] as String,
      businessType: map['businessType'] as String,
      tinNumber: map['tinNumber'] as String,
      licenseNumber: map['licenseNumber'] as String,
      license: map['license'] as String,
      tin: map['tin'] as String,
    );
  }
  String toJson() => json.encode(toMap());
  factory BusinessInfo.fromJson(String source) => BusinessInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
class Address {
 int id;
  String region;
  String subcity;
  String specificLocation;
  String city;
  String woreda;
  String houseNum;
  String phone;
  Address({
    required this.id,
    required this.region,
    required this.subcity,
    required this.specificLocation,
    required this.city,
    required this.woreda,
    required this.houseNum,
    required this.phone,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'region': region,
      'subcity': subcity,
      'specificLocation': specificLocation,
      'city': city,
      'woreda': woreda,
      'houseNum': houseNum,
      'phone': phone,
    };
  }
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as int,
      region: map['region'] as String,
      subcity: map['subcity'] as String,
      specificLocation: map['specificLocation'] as String,
      city: map['city'] as String,
      woreda: map['woreda'] as String,
      houseNum: map['houseNum'] as String,
      phone: map['phone'] as String,
    );
  }
  String toJson() => json.encode(toMap());
  factory Address.fromJson(String source) => Address.fromMap(json.decode(source) as Map<String, dynamic>);
}
