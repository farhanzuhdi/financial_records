import 'package:financial_records/core/fr_function.dart';
import 'package:financial_records/core/fr_models.dart/dropdown_item.dart';
import 'package:financial_records/core/fr_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardState with ChangeNotifier {
  BuildContext context;
  List dropdownCategory = [],
      dropdownType = [],
      dropdownMonth = [],
      dropdownYear = [];
  ItemDropdown? category, type, month;
  String? nominalText;
  TextEditingController nominal = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController categoryText = TextEditingController();
  TextEditingController typeText = TextEditingController();
  TextEditingController categorySearch = TextEditingController();
  TextEditingController monthSearch = TextEditingController();
  TextEditingController yearSearch = TextEditingController();

  DashboardState({required this.context}) {
    getData();
  }

  getData() async {
    dropdownCategory = await frfunction.getListCategory(context);

    if (!context.mounted) return;
    dropdownType = await frfunction.getListType(context);
    if (!context.mounted) return;
    dropdownMonth = await frfunction.getMonth(context);
    dropdownYear = await frfunction.getLast10Year();
    notifyListeners();
  }

  selectCategory(value) {
    category = value;
  }

  selectType(value) {
    type = value;
  }

  selectMonth(value) {
    month = value;
  }

  toList() {
    if (monthSearch.text == '' ||
        yearSearch.text == '' ||
        categorySearch.text == '') {
      return frfunction.snackbarWarning(
          context: context, message: 'Lengkapi Filter');
    } else {
      frnavigation.back(context: context);
      frnavigation.toList(
          context: context,
          month: month!.id,
          monthName: month!.name,
          year: yearSearch.text,
          categoryName: categorySearch.text);
    }
  }

  nominalTyping(value) {
    nominalText = value;

    nominal.text = frfunction.moneyFormatter(value);
    notifyListeners();
  }

  saveData() async {
    if (category != null &&
        type != null &&
        nominalText != null &&
        nominal.text != '' &&
        notes.text != '') {
      try {
        bool result = await frfunction.addData(
            context: context,
            category: category!,
            type: type!,
            nominal: nominalText!,
            notes: notes.text);
        if (result) {
          if (!context.mounted) return;
          FocusScope.of(context).unfocus();
          frfunction.snackbarSuccess(
              context: context, message: 'Data berhasil disimpan');
          category == null;
          categoryText.text = '';
          type == null;
          typeText.text = '';
          nominalText == null;
          nominal.text = '';
          notes.text = '';
        }
      } catch (e) {
        if (!context.mounted) return;
        frfunction.snackbarError(context: context, message: e.toString());
      }
    } else {
      frfunction.snackbarWarning(
          context: context, message: "Tolong, isi semua data!");
    }
  }

  closeFilterModal() {
    categorySearch.clear();
    monthSearch.clear();
    yearSearch.clear();
    frnavigation.back(context: context);
    notifyListeners();
  }
}
