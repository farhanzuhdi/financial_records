import 'package:financial_records/core/fr_function.dart';
import 'package:financial_records/core/fr_models.dart/list_item.dart';
import 'package:financial_records/core/fr_navigation.dart';
import 'package:flutter/material.dart';

class ListState with ChangeNotifier {
  BuildContext context;
  List<ItemList> listItem = [];
  final String month, year, categoryName;
  int remaining = 0;
  int necessary = 0;
  int snack = 0;
  int other = 0;

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
    frfunction.showLoadingDialog(context);
    listItem = await frfunction.getListData(
        context: context, month: month, year: year, categoryName: categoryName);
    notifyListeners();
    await countHeader();
    if (!context.mounted) return;
    frfunction.closeLoadingDialog(context);
  }

  countHeader() {
    if (listItem.isEmpty) {
      return "0";
    } else {
      for (int i = 0; i < listItem.length; i++) {
        if (listItem[i].type.id == '1') {
          remaining -= int.parse(listItem[i].nominal);
          if (listItem[i].spendingCategory.id == '1') {
            necessary += int.parse(listItem[i].nominal);
          } else if (listItem[i].spendingCategory.id == '2') {
            snack += int.parse(listItem[i].nominal);
          } else if (listItem[i].spendingCategory.id == '3') {
            other += int.parse(listItem[i].nominal);
          }
        } else {
          remaining += int.parse(listItem[i].nominal);
        }
      }
    }
  }
}
