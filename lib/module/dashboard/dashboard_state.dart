import 'package:financial_records/core/fr_function.dart';
import 'package:financial_records/core/fr_models.dart/dropdown_item.dart';
import 'package:financial_records/core/fr_navigation.dart';
import 'package:flutter/material.dart';

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
    frfunction.showLoadingDialog(context);
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
          frfunction.sendNotification('${category!.name} ${type!.name}',
              'Rp ${frfunction.moneyFormatter(nominalText!)} ${type!.id == '1' ? 'Untuk' : 'Dari'} ${notes.text}');
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
    if (!context.mounted) return;
    frfunction.closeLoadingDialog(context);
  }

  closeFilterModal() {
    categorySearch.clear();
    monthSearch.clear();
    yearSearch.clear();
    frnavigation.back(context: context);
    notifyListeners();
  }

  showFilter(BuildContext context) async {
    if (dropdownCategory.isEmpty ||
        dropdownMonth.isEmpty ||
        dropdownYear.isEmpty) {
      frfunction.showLoadingDialog(context);
      await getData();
      if (!context.mounted) return;
      frfunction.closeLoadingDialog(context);
      showFilter(context);
    } else {
      showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: ((context) {
          return SizedBox(
            height: 327.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.transparent,
                      ),
                    ),
                    const Text(
                      'Lihat Data',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      onPressed: () => closeFilterModal(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  height: 55.0,
                  child: DropdownMenu(
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                    expandedInsets:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    dropdownMenuEntries: dropdownCategory
                        .map(
                          (value) => DropdownMenuEntry(
                              value: value, label: value.name),
                        )
                        .toList(),
                    label: const Text("Siapa?"),
                    controller: categorySearch,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  height: 55.0,
                  child: DropdownMenu(
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                    expandedInsets:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    dropdownMenuEntries: dropdownMonth
                        .map(
                          (value) => DropdownMenuEntry(
                              value: value, label: value.name),
                        )
                        .toList(),
                    label: const Text("Bulan?"),
                    controller: monthSearch,
                    onSelected: selectMonth,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  height: 55.0,
                  child: DropdownMenu(
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
                    expandedInsets:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    dropdownMenuEntries: dropdownYear
                        .map(
                          (value) =>
                              DropdownMenuEntry(value: value, label: value),
                        )
                        .toList(),
                    label: const Text("Tahun?"),
                    controller: yearSearch,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(width: 0.5, color: Colors.grey),
                    color: Colors.blueAccent[700],
                  ),
                  child: TextButton.icon(
                    onPressed: () => toList(),
                    icon: const Icon(
                      Icons.manage_search_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Cari",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      );
    }
  }
}
