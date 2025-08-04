import 'dart:convert';

import '../../../../core/helper/string_format_helper.dart';
import '../ride/ride_model.dart';

PusherResponseModel pusherResponseModelFromJson(String str) => PusherResponseModel.fromJson(json.decode(str));

class PusherResponseModel {
  String? channelName;
  String? eventName;
  Data? data;
  PusherResponseModel({this.channelName, this.eventName, this.data});
  PusherResponseModel copyWith({
    String? channelName,
    String? eventName,
    Data? data,
  }) =>
      PusherResponseModel(
        channelName: channelName.toString(),
        eventName: eventName.toString(),
        data: data,
      );
  factory PusherResponseModel.fromJson(Map<String, dynamic> json) {
    return PusherResponseModel(
      channelName: json["channelName"].toString(),
      eventName: json["eventName"].toString(),
      data: Data.fromJson(json["data"]),
    );
  }
}

class Data {
  String? remark;
  String? userId;
  String? driverId;
  String? rideId;
  String? message;
  String? driverLatitude;
  String? driverLongitude;
  RideModel? ride;
  // BidModel? bid;
  Data({
    this.remark,
    this.userId,
    this.driverId,
    this.rideId,
    this.message,
    this.driverLatitude,
    this.driverLongitude,
    this.ride,
    // this.bid,
  });
  Data copyWith({
    String? channelName,
    String? eventName,
    String? remark,
    String? userId,
    String? driverId,
    String? rideId,
    String? message,
    String? driverLatitude,
    String? driverLongitude,
    RideModel? ride,
    // BidModel? bid,
  }) =>
      Data(
        remark: remark.toString(),
        userId: userId.toString(),
        driverId: driverId.toString(),
        rideId: rideId.toString(),
        message: message ?? '',
        driverLatitude: driverLatitude ?? '',
        driverLongitude: driverLongitude ?? '',
        ride: ride,
        // bid: bid,
      );
  factory Data.fromJson(Map<String, dynamic> json) {
    printX(json);
    return Data(
      remark: json["remark"].toString(),
      userId: json["userId"].toString(),
      driverId: json["driverId"].toString(),
      rideId: json["rideId"].toString(),
      message: json["message"],
      driverLatitude: json["latitude"].toString(),
      driverLongitude: json["longitude"].toString(),
      ride: json["ride"] != null ? RideModel.fromJson(json["ride"]) : null,
      // bid: json["bid"] != null ? BidModel.fromJson(json["bid"]) : null,
    );
  }
}
