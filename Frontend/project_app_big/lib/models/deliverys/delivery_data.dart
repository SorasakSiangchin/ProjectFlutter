import 'dart:convert';

List<DeliveryData> deliveryDataFromJson(String str) => List<DeliveryData>.from(json.decode(str).map((x) => DeliveryData.fromJson(x)));

String deliveryDataToJson(List<DeliveryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveryData {
    DeliveryData({
        this.id = 0,
        this.statusName ="",
        required this.delivery,
    });
    
    int id;
    String statusName;
    List<dynamic> delivery;

    factory DeliveryData.fromJson(Map<String, dynamic> json) => DeliveryData(
        id: json["id"],
        statusName: json["statusName"],
        delivery: List<dynamic>.from(json["delivery"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "statusName": statusName,
        "delivery": List<dynamic>.from(delivery.map((x) => x)),
    };
}
