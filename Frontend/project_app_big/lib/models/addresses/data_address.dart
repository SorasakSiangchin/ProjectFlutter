import 'dart:convert';
List<DataAddress> dataAddressFromJson(String str) => List<DataAddress>.from(json.decode(str).map((x) => DataAddress.fromJson(x)));

 DataAddress dataAddressToJson(String str) => DataAddress.fromJson(json.decode(str));

class DataAddress {
    DataAddress({
        this.id = "",
        this.addressData = "",
        this.addressDetail = "",
        this.userName = "",
        this.telUser = "",
    });

    String id;
    String addressData;
    String addressDetail;
    String userName;
    String telUser;

    factory DataAddress.fromJson(Map<String, dynamic> json) => DataAddress(
        id: json["id"],
        addressData: json["addressData"],
        addressDetail: json["addressDetail"],
        userName: json["userName"],
        telUser: json["telUser"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "addressData": addressData,
        "addressDetail": addressDetail,
        "userName": userName,
        "telUser": telUser,
    };
}
