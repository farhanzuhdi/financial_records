import 'package:financial_records/core/fr_function.dart';
import 'package:financial_records/core/fr_models.dart/list_item.dart';
import 'package:financial_records/core/fr_navigation.dart';
import 'package:flutter/material.dart';

class ListState with ChangeNotifier {
  BuildContext context;
  List<ItemList> listItem = [];
  final String month, year, categoryName;

  ListState({
    required this.context,
    required this.month,
    required this.year,
    required this.categoryName,
  }) {
    getData();
  }

  toDashboard() {
    frnavigation.toDashboard(context: context);
  }

  getData() async {
    listItem = await frfunction.getListData(
        context: context, month: month, year: year, categoryName: categoryName);
    notifyListeners();
  }
}
