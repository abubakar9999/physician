import 'dart:convert';

OrderApprovalModel orderApprovalModelFromJson(String str) =>
    OrderApprovalModel.fromJson(json.decode(str));

String orderApprovalModelToJson(OrderApprovalModel data) =>
    json.encode(data.toJson());

class OrderApprovalModel {
  String? status;
  List<AreaList>? areaList;

  OrderApprovalModel({
    this.status,
    this.areaList,
  });

  factory OrderApprovalModel.fromJson(Map<String, dynamic> json) =>
      OrderApprovalModel(
        status: json["status"],
        areaList: json["area_list"] != null
            ? List<AreaList>.from(
                json["area_list"].map((x) => AreaList.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "area_list": areaList != null
            ? List<dynamic>.from(areaList!.map((x) => x.toJson()))
            : null,
      };
}

class AreaList {
  String? areaId;
  String? areaName;
  List<ClientList>? clientList;

  AreaList({
    this.areaId,
    this.areaName,
    this.clientList,
  });

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
        areaId: json["area_id"],
        areaName: json["area_name"],
        clientList: json["clientList"] != null
            ? List<ClientList>.from(
                json["clientList"].map((x) => ClientList.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "area_name": areaName,
        "clientList": clientList != null
            ? List<dynamic>.from(clientList!.map((x) => x.toJson()))
            : null,
      };
}

class ClientList {
  String? clientId;
  String? clientName;
  String? categoryName;
  String? address;
  String? outstanding;
  List<Order>? orders;

  ClientList({
    this.clientId,
    this.clientName,
    this.categoryName,
    this.address,
    this.outstanding,
    this.orders,
  });

  factory ClientList.fromJson(Map<String, dynamic> json) => ClientList(
        clientId: json["client_id"],
        clientName: json["client_name"],
        categoryName: json["category_name"],
        address: json["address"],
        outstanding: json["outstanding"],
        orders: json["orders"] != null
            ? List<Order>.from(json["orders"].map((x) => Order.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name": clientName,
        "category_name": categoryName,
        "address": address,
        "outstanding": outstanding,
        "orders": orders != null
            ? List<dynamic>.from(orders!.map((x) => x.toJson()))
            : null,
      };
}

class Order {
  String? orderSerial;
  String? deliveryDate; // Changed to String
  String? collectionDate; // Changed to String
  String? deliveryTime;
  String? paymentMode;
  String? offer;
  String? note;
  String? latitude;
  String? longitude;
  String? locationDetail;
  String? submittedBy;
  List<ItemList>? itemList;

  Order({
    this.orderSerial,
    this.deliveryDate,
    this.collectionDate,
    this.deliveryTime,
    this.paymentMode,
    this.offer,
    this.note,
    this.latitude,
    this.longitude,
    this.locationDetail,
    this.submittedBy,
    this.itemList,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderSerial: json["order_serial"],
        deliveryDate: json["delivery_date"],
        collectionDate: json["collection_date"],
        deliveryTime: json["delivery_time"],
        paymentMode: json["payment_mode"],
        offer: json["offer"],
        note: json["note"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        locationDetail: json["location_detail"],
        submittedBy: json["submitted_by"],
        itemList: json["item_list"] != null
            ? List<ItemList>.from(
                json["item_list"].map((x) => ItemList.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "order_serial": orderSerial,
        "delivery_date": deliveryDate,
        "collection_date": collectionDate,
        "delivery_time": deliveryTime,
        "payment_mode": paymentMode,
        "offer": offer,
        "note": note,
        "latitude": latitude,
        "longitude": longitude,
        "location_detail": locationDetail,
        "submitted_by": submittedBy,
        "item_list": itemList != null
            ? List<dynamic>.from(itemList!.map((x) => x.toJson()))
            : null,
      };
}

class ItemList {
  int? quantity;
  String? itemName;
  double? tp;
  String? itemId;
  String? categoryId;
  double? vat;
  String? manufacturer;

  ItemList({
    this.quantity,
    this.itemName,
    this.tp,
    this.itemId,
    this.categoryId,
    this.vat,
    this.manufacturer,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        quantity: json["quantity"],
        itemName: json["item_name"],
        tp: json["tp"] != null ? json["tp"].toDouble() : null,
        itemId: json["item_id"],
        categoryId: json["category_id"],
        vat: json["vat"].toDouble(),
        manufacturer: json["manufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "item_name": itemName,
        "tp": tp,
        "item_id": itemId,
        "category_id": categoryId,
        "vat": vat,
        "manufacturer": manufacturer,
      };
}
