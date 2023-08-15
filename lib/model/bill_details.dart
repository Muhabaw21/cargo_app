// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final billDetail = billDetailFromJson(jsonString);

import 'dart:convert';

class BillDetail {
  final dynamic amount;
  final int cargo;
  final String pickUp;
  final String dropOff;
  final String payment;
  final String cargoType;
  final dynamic paymentDeadline;
  final dynamic daysForDeadline;
  BillDetail({
    required this.amount,
    required this.cargo,
    required this.pickUp,
    required this.dropOff,
    required this.payment,
    required this.cargoType,
    required this.paymentDeadline,
    required this.daysForDeadline,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'cargo': cargo,
      'pickUp': pickUp,
      'dropOff': dropOff,
      'payment': payment,
      'cargoType': cargoType,
      'paymentDeadline': paymentDeadline,
      'daysForDeadline': daysForDeadline,
    };
  }

  factory BillDetail.fromMap(Map<String, dynamic> map) {
    return BillDetail(
      amount: map['amount'] as dynamic,
      cargo: map['cargo'] as int,
      pickUp: map['pickUp'] as String,
      dropOff: map['dropOff'] as String,
      payment: map['payment'] as String,
      cargoType: map['cargoType'] as String,
      paymentDeadline: map['paymentDeadline'] as dynamic,
      daysForDeadline: map['daysForDeadline'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillDetail.fromJson(String source) =>
      BillDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
