class User {
  int? id;
  String? loginBy;
  String? zoneId;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? avatar;
  String? countryCode;
  String? mobile;
  String? totalReviews;
  String? avgRating;
  String? onlineStatus;
  String? status;
  String? dv;
  String? vv;
  String? riderRuleId;
  String? ev;
  String? sv;
  String? profileComplete;
  String? verCodeSendAt;
  String? tv;
  String? tsc;
  String? ts;
  String? banReason;
  String? isDeleted;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? countryName;
  String? dialCode;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.loginBy,
    this.zoneId,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.avatar,
    this.countryCode,
    this.mobile,
    this.totalReviews,
    this.avgRating,
    this.onlineStatus,
    this.status,
    this.dv,
    this.vv,
    this.riderRuleId,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.tv,
    this.tsc,
    this.ts,
    this.banReason,
    this.isDeleted,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.countryName,
    this.dialCode,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        loginBy: json["login_by"] != null ? json["login_by"].toString() : "",
        zoneId: json["zone_id"] != null ? json["zone_id"].toString() : "",
        firstname: json["firstname"] != null ? json["firstname"].toString() : "",
        lastname: json["lastname"] != null ? json["lastname"].toString() : "",
        username: json["username"] != null ? json["username"].toString() : "",
        email: json["email"] != null ? json["email"].toString() : "",
        avatar: json["avatar"] != null ? json["avatar"].toString() : "",
        countryCode: json["country_code"] != null ? json["country_code"].toString() : "",
        mobile: json["mobile"] != null ? json["mobile"].toString() : "",
        totalReviews: json["total_reviews"] != null ? json["total_reviews"].toString() : "",
        avgRating: json["avg_rating"] != null ? json["avg_rating"].toString() : "",
        onlineStatus: json["online_status"] != null ? json["online_status"].toString() : "",
        status: json["status"] != null ? json["status"].toString() : "",
        dv: json["dv"] != null ? json["dv"].toString() : "",
        vv: json["vv"] != null ? json["vv"].toString() : "",
        riderRuleId: json["rider_rule_id"] != null ? json["rider_rule_id"].toString() : "",
        ev: json["ev"] != null ? json["ev"].toString() : "",
        sv: json["sv"] != null ? json["sv"].toString() : "",
        profileComplete: json["profile_complete"] != null ? json["profile_complete"].toString() : "",
        verCodeSendAt: json["ver_code_send_at"] != null ? json["ver_code_send_at"].toString() : "",
        tv: json["tv"] != null ? json["tv"].toString() : "",
        tsc: json["tsc"] != null ? json["tsc"].toString() : "",
        ts: json["ts"] != null ? json["ts"].toString() : "",
        banReason: json["ban_reason"] != null ? json["ban_reason"].toString() : "",
        isDeleted: json["is_deleted"] != null ? json["is_deleted"].toString() : "",
        address: json["address"] != null ? json["address"].toString() : "",
        city: json["city"] != null ? json["city"].toString() : "",
        state: json["state"] != null ? json["state"].toString() : "",
        zip: json["zip"] != null ? json["zip"].toString() : "",
        countryName: json["country_name"] != null ? json["country_name"].toString() : "",
        dialCode: json["dial_code"] != null ? json["dial_code"].toString() : "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "login_by": loginBy,
        "zone_id": zoneId,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "avatar": avatar,
        "country_code": countryCode,
        "mobile": mobile,
        "total_reviews": totalReviews,
        "avg_rating": avgRating,
        "online_status": onlineStatus,
        "status": status,
        "dv": dv,
        "vv": vv,
        "rider_rule_id": riderRuleId,
        "ev": ev,
        "sv": sv,
        "profile_complete": profileComplete,
        "ver_code_send_at": verCodeSendAt,
        "tv": tv,
        "tsc": tsc,
        "ts": ts,
        "ban_reason": banReason,
        "is_deleted": isDeleted,
        "address": address,
        "city": city,
        "state": state,
        "zip": zip,
        "country_name": countryName,
        "dial_code": dialCode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
