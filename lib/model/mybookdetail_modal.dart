// To parse this JSON data, do
//
//     final myBookDetailModal = myBookDetailModalFromJson(jsonString);

import 'dart:convert';

import 'bookdetails_modal.dart';

MyBookDetailModal myBookDetailModalFromJson(String str) => MyBookDetailModal.fromJson(json.decode(str));

String myBookDetailModalToJson(MyBookDetailModal data) => json.encode(data.toJson());

class MyBookDetailModal {
  List<BookDetail> bookDetails;
  String responseCode;
  String result;
  String responseMsg;

  MyBookDetailModal({
    required this.bookDetails,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory MyBookDetailModal.fromJson(Map<String, dynamic> json) => MyBookDetailModal(
    bookDetails: List<BookDetail>.from(json["book_details"].map((x) => BookDetail.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "book_details": List<dynamic>.from(bookDetails.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
