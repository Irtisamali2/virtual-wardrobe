import 'dart:convert';

DataModel dataModelFromJson(String str) {
  
  final jsonData = json.decode(str);
  return DataModel.fromJson(jsonData);
}
  // DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  String? category;
  List<dynamic>? url;

  DataModel({
    this.category,
    this.url,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      category: json["category"],
      url: List<dynamic>.from(json["url"].map((x) => x)),
    );
  }
  Map<String, dynamic> toJson() => {
        "category": category,
        "url": List<dynamic>.from(url!.map((x) => x)),
      };
}
