// To parse this JSON data, do
//
//     final bookHistoryModal = bookHistoryModalFromJson(jsonString);

import 'dart:convert';

import 'bookdetails_modal.dart';

BookHistoryModal bookHistoryModalFromJson(Map<String, dynamic>  str) => BookHistoryModal.fromJson(str);

String bookHistoryModalToJson(BookHistoryModal data) => json.encode(data.toJson());

class BookHistoryModal {
  List<BookDetail> bookHistory;

  String responseCode;
  String result;
  String responseMsg;

  BookHistoryModal({
    required this.bookHistory,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory BookHistoryModal.fromJson(Map<String, dynamic> json) => BookHistoryModal(

    bookHistory: List<BookDetail>.from(json["book_history"].map((x) => BookDetail.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "book_history": List<dynamic>.from(bookHistory.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
