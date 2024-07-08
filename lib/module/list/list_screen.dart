import 'package:financial_records/core/fr_function.dart';
import 'package:financial_records/module/list/list_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen(
      {super.key,
      required this.month,
      required this.year,
      required this.monthName,
      required this.categoryName});
  final String month, monthName, year, categoryName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListState>(
      create: (BuildContext context) => ListState(
        context: context,
        month: month,
        year: year,
        categoryName: categoryName,
      ),
      child: Consumer<ListState>(
        builder: (_, listState, __) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) => listState.toDashboard(),
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => listState.toDashboard(),
                  ),
                  title: Text(
                    "Daftar $monthName $year",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.indigoAccent,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      margin: const EdgeInsets.only(bottom: 4.0),
                      decoration: const BoxDecoration(
                        color: Colors.indigoAccent,
                        border: Border(
                            top: BorderSide(color: Colors.white, width: 1.0)),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sisa Saldo $categoryName :',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Rp ${frfunction.remainingBalanceFormat(listState.listItem)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: listState.listItem
                            .map(
                              (data) => Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 4.0, bottom: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${frfunction.datetoDayFormat(data.date)}, ${data.date.day.toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0),
                                          ),
                                          SizedBox(
                                            width: 75,
                                            child: Text(
                                                '${frfunction.formatTime(data.date.hour.toString())}:${frfunction.formatTime(data.date.minute.toString())}:${frfunction.formatTime(data.date.second.toString())}'),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            data.type.name,
                                            style: TextStyle(
                                                color: data.type.id == "2"
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Icon(
                                            data.type.id == "2"
                                                ? Icons
                                                    .keyboard_double_arrow_down_rounded
                                                : Icons
                                                    .keyboard_double_arrow_up_rounded,
                                            color: data.type.id == "2"
                                                ? Colors.green
                                                : Colors.red,
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Rp ${frfunction.moneyFormatter(data.nominal)}',
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(data.notes),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList()
                            .reversed
                            .toList(),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
