
import 'dart:convert';
List<Address> addressFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

 Address addressToJson(String str) => Address.fromJson(json.decode(str));

class Address {
    Address({
        this.id = "",
        this.idUser = 0,
        this.idDataAddress = "",
        required this.idDataAddressNavigation,
        required this.order,
    });

    String id;
    int idUser;
    String idDataAddress;
    late IdDataAddressNavigation idDataAddressNavigation;
    List<dynamic> order;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        idUser: json["idUser"],
        idDataAddress: json["idDataAddress"],
        idDataAddressNavigation: IdDataAddressNavigation.fromJson(json["idDataAddressNavigation"]),
        order: List<dynamic>.from(json["order"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idUser": idUser,
        "idDataAddress": idDataAddress,
        "idDataAddressNavigation": idDataAddressNavigation.toJson(),
        "order": List<dynamic>.from(order.map((x) => x)),
    };
}

class IdDataAddressNavigation {
    IdDataAddressNavigation({
        this.id = "",
        this.addressData= "",
        this.addressDetail= "",
        this.userName= "",
        this.telUser= "",
        required this.address,
    });

    String id;
    String addressData;
    String addressDetail;
    String userName;
    String telUser;
    List<dynamic> address;

    factory IdDataAddressNavigation.fromJson(Map<String, dynamic> json) => IdDataAddressNavigation(
        id: json["id"],
        addressData: json["addressData"],
        addressDetail: json["addressDetail"],
        userName: json["userName"],
        telUser: json["telUser"],
        address: List<dynamic>.from(json["address"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "addressData": addressData,
        "addressDetail": addressDetail,
        "userName": userName,
        "telUser": telUser,
        "address": List<dynamic>.from(address.map((x) => x)),
    };
}
