// To parse this JSON data, do
//
//     final openTraderList = openTraderListFromJson(jsonString);

import 'dart:convert';

List<OpenTraderList> openTraderListFromJson(String str) => List<OpenTraderList>.from(json.decode(str).map((x) => OpenTraderList.fromJson(x)));

String openTraderListToJson(List<OpenTraderList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OpenTraderList {
  double? currentPrice;
  dynamic comment;
  dynamic digits;
  dynamic login;
  dynamic openPrice;
  DateTime? openTime;
  dynamic profit;
  dynamic sl;
  dynamic swaps;
  dynamic symbol;
  dynamic tp;
  dynamic ticket;
  dynamic type;
  dynamic volume;

  OpenTraderList({
    this.currentPrice,
    this.comment,
    this.digits,
    this.login,
    this.openPrice,
    this.openTime,
    this.profit,
    this.sl,
    this.swaps,
    this.symbol,
    this.tp,
    this.ticket,
    this.type,
    this.volume,
  });

  factory OpenTraderList.fromJson(Map<String, dynamic> json) => OpenTraderList(
    currentPrice: json["currentPrice"]?.toDouble(),
    comment: json["comment"],
    digits: json["digits"],
    login: json["login"],
    openPrice: json["openPrice"],
    openTime: json["openTime"] == null ? null : DateTime.parse(json["openTime"]),
    profit: json["profit"],
    sl: json["sl"],
    swaps: json["swaps"],
    symbol: json["symbol"],
    tp: json["tp"],
    ticket: json["ticket"],
    type: json["type"],
    volume: json["volume"],
  );

  Map<String, dynamic> toJson() => {
    "currentPrice": currentPrice,
    "comment": comment,
    "digits": digits,
    "login": login,
    "openPrice": openPrice,
    "openTime": openTime?.toIso8601String(),
    "profit": profit,
    "sl": sl,
    "swaps": swaps,
    "symbol": symbol,
    "tp": tp,
    "ticket": ticket,
    "type": type,
    "volume": volume,
  };
}
