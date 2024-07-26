import 'dart:convert';

import 'package:financial_records/core/fr_models.dart/dropdown_item.dart';
import 'package:financial_records/core/fr_models.dart/list_item.dart';
import 'package:financial_records/core/fr_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FRFunction {
  Future<List<ItemDropdown>> getListCategory(BuildContext context) async {
    DatabaseReference databaseReferenceCategory =
        FirebaseDatabase.instance.ref().child('category');
    List<ItemDropdown> returnData = [];
    try {
      final data = databaseReferenceCategory.once();
      await data.then((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        for (var element in dataSnapshot.children) {
          returnData.add(ItemDropdown(
              id: element.key.toString(), name: element.value.toString()));
        }
      });
      return returnData;
    } catch (e) {
      snackbarError(
          context: !context.mounted ? context : context, message: e.toString());
      return returnData;
    }
  }

  Future<List<ItemDropdown>> getListType(BuildContext context) async {
    DatabaseReference databaseReferenceType =
        FirebaseDatabase.instance.ref().child('type');
    List<ItemDropdown> returnData = [];
    try {
      final data = databaseReferenceType.once();
      await data.then((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        for (var element in dataSnapshot.children) {
          returnData.add(ItemDropdown(
              id: element.key.toString(), name: element.value.toString()));
        }
      });
      return returnData;
    } catch (e) {
      snackbarError(
          context: !context.mounted ? context : context, message: e.toString());
      return returnData;
    }
  }

  Future<List<ItemDropdown>> getListSpendingCategory(
      BuildContext context) async {
    DatabaseReference databaseReferenceType =
        FirebaseDatabase.instance.ref().child('spending_category');
    List<ItemDropdown> returnData = [];
    try {
      final data = databaseReferenceType.once();
      await data.then((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        for (var element in dataSnapshot.children) {
          returnData.add(ItemDropdown(
              id: element.key.toString(), name: element.value.toString()));
        }
      });
      return returnData;
    } catch (e) {
      snackbarError(
          context: !context.mounted ? context : context, message: e.toString());
      return returnData;
    }
  }

  Future<List<ItemList>> getListData(
      {required BuildContext context,
      required String month,
      required String year,
      required String categoryName}) async {
    DatabaseReference databaseReferenceData =
        FirebaseDatabase.instance.ref().child('data');
    List<ItemList> returnData = [];
    String monthString = '';
    if (month.length < 2) {
      monthString = '0$month';
    } else {
      monthString = month;
    }
    String endDay =
        getDaysInMonth(int.parse(year), int.parse(month)).toString();
    String start = '$year-$monthString-01 00:00:00';
    String end = '$year-$monthString-$endDay 23:59:59';
    try {
      final data = databaseReferenceData
          .orderByChild('date')
          .startAt(start)
          .endAt(end)
          .once();
      await data.then((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        for (var element in dataSnapshot.children) {
          ItemList data =
              ItemList.fromJson(jsonDecode(jsonEncode(element.value)));
          if (data.category.name == categoryName) {
            returnData.add(data);
          }
        }
      });

      return returnData;
    } catch (e) {
      snackbarError(
          context: !context.mounted ? context : context, message: e.toString());
      return returnData;
    }
  }

  Future<bool> addData(
      {required BuildContext context,
      required ItemDropdown category,
      required ItemDropdown type,
      required String nominal,
      required String notes}) async {
    DatabaseReference databaseReferenceData =
        FirebaseDatabase.instance.ref().child('data');
    DateTime nowFormat = DateTime.now();
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(nowFormat);
    try {
      await databaseReferenceData.child('$formattedDate ${category.id}').set({
        'date': formattedDate,
        'category': category.toJson(),
        'type': type.toJson(),
        'nominal': nominal,
        'notes': notes
      });
      return true;
    } catch (e) {
      snackbarError(
          context: !context.mounted ? context : context, message: e.toString());
      return false;
    }
  }

  String moneyFormatter(String value) {
    MoneyFormatter formatter = MoneyFormatter(
        amount: int.parse(value).toDouble(),
        settings: MoneyFormatterSettings(
          symbol: 'IDR',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 3,
          compactFormatType: CompactFormatType.long,
        ));
    return formatter.output.withoutFractionDigits;
  }

  int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }

  Future<List> getLast10Year() async {
    List result = [];
    for (int i = 0; i < 10; i++) {
      result.add((DateTime.now().year - i).toString());
    }
    return result.reversed.toList();
  }

  Future<List<ItemDropdown>> getMonth(BuildContext context) async {
    DatabaseReference databaseReferenceMonth =
        FirebaseDatabase.instance.ref().child('month');
    List<ItemDropdown> returnData = [];
    try {
      final data = databaseReferenceMonth.once();
      await data.then((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        for (var element in dataSnapshot.children) {
          returnData.add(ItemDropdown(
              id: element.key.toString(), name: element.value.toString()));
        }
      });
      return returnData;
    } catch (e) {
      snackbarError(
          context: !context.mounted ? context : context, message: e.toString());
      return returnData;
    }
  }

  String datetoDayFormat(DateTime date) {
    return DateFormat.EEEE('id_ID').format(date);
  }

  String remainingBalanceFormat(List<ItemList> list) {
    if (list.isEmpty) {
      return "0";
    } else {
      int total = 0;
      for (int i = 0; i < list.length; i++) {
        if (list[i].type.id == '1') {
          total -= int.parse(list[i].nominal);
        } else {
          total += int.parse(list[i].nominal);
        }
      }
      return moneyFormatter(total.toString());
    }
  }

  String formatTime(String value) {
    return value.length > 1 ? value : '0$value';
  }

  void snackbarSuccess(
      {required BuildContext context, required String message}) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: message),
      animationDuration: const Duration(milliseconds: 3000),
    );
  }

  void snackbarError({required BuildContext context, required String message}) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
      animationDuration: const Duration(milliseconds: 3000),
    );
  }

  void snackbarWarning(
      {required BuildContext context, required String message}) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(message: message),
      animationDuration: const Duration(milliseconds: 3000),
    );
  }

  showLoadingDialog(context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              child: LoadingAnimationWidget.hexagonDots(
                  color: Colors.grey.shade200, size: 50),
            );
          });
    });
  }

  closeLoadingDialog(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pop();
    });
  }

  sendNotification(String title, String body) async {
    await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic ${frstring.restApiKey}',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": frstring.oneSignalId,
        "included_segments": ["Active Subscriptions"],
        "target_channel": "push",
        "android_accent_color": "FF9976D2",
        "small_icon": "@mipmap/fire_icon",
        "large_icon": "@mipmap/fire_icon",
        "headings": {"en": title},
        "contents": {"en": body},
      }),
    );
  }
}

var frfunction = FRFunction();
