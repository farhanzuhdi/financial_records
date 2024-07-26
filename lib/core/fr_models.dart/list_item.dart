import 'package:financial_records/core/fr_models.dart/dropdown_item.dart';

class ItemList {
  ItemDropdown category;
  DateTime date;
  String nominal;
  String notes;
  ItemDropdown type;
  ItemDropdown spendingCategory;

  ItemList(
      {required this.category,
      required this.date,
      required this.nominal,
      required this.notes,
      required this.type,
      required this.spendingCategory});

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      category: ItemDropdown.fromJson(json['category']),
      date: DateTime.parse(json['date']),
      nominal: json['nominal'],
      notes: json['notes'],
      type: ItemDropdown.fromJson(json['type']),
      spendingCategory: json['spending_category'] == null
          ? ItemDropdown(id: '', name: '')
          : ItemDropdown.fromJson(json['spending_category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'date': date.toIso8601String(),
      'nominal': nominal,
      'notes': notes,
      'type': type.toJson(),
      'spending_category': spendingCategory.toJson(),
    };
  }
}
