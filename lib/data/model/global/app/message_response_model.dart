// To parse this JSON data, do
//
//     final messageResponseModel = messageResponseModelFromJson(jsonString);

import 'dart:convert';

MessageResponseModel messageResponseModelFromJson(String str) => MessageResponseModel.fromJson(json.decode(str));

class MessageResponseModel {
  Data? data;

  MessageResponseModel({
    this.data,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) => MessageResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Message? message;

  Data({
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
      );
}

class Message {
  String? rideId;
  String? userId;
  String? driverId;
  String? message;
  String? image;
  String? updatedAt;
  String? createdAt;
  String? id;

  Message({
    this.rideId,
    this.userId,
    this.driverId,
    this.message,
    this.updatedAt,
    this.createdAt,
    this.image,
    this.id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      rideId: json["ride_id"] != null ? json["ride_id"].toString() : "",
      userId: json["user_id"] != null ? json["user_id"].toString() : "",
      driverId: json["driver_id"] != null ? json["driver_id"].toString() : "0",
      message: json["message"] != null ? json["message"].toString() : "",
      image: json["image"] != null ? json["image"].toString() : "",
      updatedAt: json["updated_at"] != null ? json["updated_at"].toString() : "",
      createdAt: json["created_at"] != null ? json["created_at"].toString() : "",
      id: json["id"] != null ? json["id"].toString() : "",
    );
  }
}
