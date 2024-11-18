// To parse this JSON data, do
//
//     final goodsCategoryListModel = goodsCategoryListModelFromJson(jsonString);

import 'dart:convert';

GoodsCategoryListModel goodsCategoryListModelFromJson(String str) => GoodsCategoryListModel.fromJson(json.decode(str));

String goodsCategoryListModelToJson(GoodsCategoryListModel data) => json.encode(data.toJson());

class GoodsCategoryListModel {
    bool ?status;
    String ?message;
    List<GoodsCatList>? data;

    GoodsCategoryListModel({
        this.status,
        this.message,
        this.data,
    });

    factory GoodsCategoryListModel.fromJson(Map<String, dynamic> json) => GoodsCategoryListModel(
        status: json["status"],
        message: json["message"],
        data: List<GoodsCatList>.from(json["data"].map((x) => GoodsCatList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class GoodsCatList {
    String ?goodsName;
    String ?goodsDes;
    int ?goodsId;

    GoodsCatList({
        this.goodsName,
        this.goodsDes,
        this.goodsId,
    });

    factory GoodsCatList.fromJson(Map<String, dynamic> json) => GoodsCatList(
        goodsName: json["goods_name"],
        goodsDes: json["goods_description"],
        goodsId: json["goods_id"],
    );

    Map<String, dynamic> toJson() => {
        "goods_name": goodsName,
        "goods_id": goodsId,
    };
}
