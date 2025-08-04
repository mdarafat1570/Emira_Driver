import 'dart:convert';

import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';

ActiveRideResponseModel activeRideResponseModelFromJson(String str) => ActiveRideResponseModel.fromJson(json.decode(str));

class ActiveRideResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  ActiveRideResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory ActiveRideResponseModel.fromJson(Map<String, dynamic> json) => ActiveRideResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
