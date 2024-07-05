import 'package:financial_records/core/fr_models.dart/dropdown_item.dart';

class ItemList {
  ItemDropdown category;
  DateTime date;
  String nominal;
  String notes;
  ItemDropdown type;

  ItemList(
      {required this.category,
      required this.date,
      required this.nominal,
      required this.notes,
      required this.type});

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      category: ItemDropdown.fromJson(json['category']),
      date: DateTime.parse(json['date']),
      nominal: json['nominal'],
      notes: json['notes'],
      type: ItemDropdown.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'date': date.toIso8601String(),
      'nominal': nominal,
      'notes': notes,
      'type': type.toJson(),
    };
  }
}
