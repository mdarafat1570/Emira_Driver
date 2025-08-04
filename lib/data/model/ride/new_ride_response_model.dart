import 'dart:convert';

import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';

NewRideListResponseModel cancelRideListResponseModelFromJson(String str) => NewRideListResponseModel.fromJson(json.decode(str));

class NewRideListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  NewRideListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory NewRideListResponseModel.fromJson(Map<String, dynamic> json) => NewRideListResponseModel(
        remark: json["remark"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
      );
}

class Data {
  Rides? rides;

  Data({
    this.rides,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rides: json["rides"] == null ? null : Rides.fromJson(json["rides"]),
      );
}

class Rides {
  List<RideModel>? data;
  dynamic nextPageUrl;

  Rides({
    this.data,
    this.nextPageUrl,
  });

  factory Rides.fromJson(Map<String, dynamic> json) => Rides(
        data: json["data"] == null ? [] : List<RideModel>.from(json["data"]!.map((x) => RideModel.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );
}
