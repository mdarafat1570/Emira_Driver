import 'dart:convert';

import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';

AcceptedRideResponseModel cancelRideListResponseModelFromJson(String str) => AcceptedRideResponseModel.fromJson(json.decode(str));

class AcceptedRideResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  AcceptedRideResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory AcceptedRideResponseModel.fromJson(Map<String, dynamic> json) => AcceptedRideResponseModel(
        remark: json["remark"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
      );
}

class Data {
  Rides? rides;
  String? userImagePath;

  Data({
    this.rides,
    this.userImagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rides: json["rides"] == null ? null : Rides.fromJson(json["rides"]),
        userImagePath: json["user_image_path"],
      );

  Map<String, dynamic> toJson() => {
        "rides": rides?.toJson(),
      };
}

class Rides {
  List<RideModel>? data;
  String? nextPageUrl;

  Rides({
    this.data,
    this.nextPageUrl,
  });

  factory Rides.fromJson(Map<String, dynamic> json) => Rides(
        data: json["data"] == null ? [] : List<RideModel>.from(json["data"]!.map((x) => RideModel.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
