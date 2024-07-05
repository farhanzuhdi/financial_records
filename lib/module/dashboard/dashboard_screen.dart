import 'package:financial_records/module/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardState>(
      create: (BuildContext context) => DashboardState(context: context),
      child: Consumer<DashboardState>(
        builder: (_, dashboardState, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Tambah Catatan",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (dashboardState.dropdownCategory.isEmpty ||
                          dashboardState.dropdownMonth.isEmpty ||
                          dashboardState.dropdownYear.isEmpty) {
                        return;
                      } else {
                        showFilter(context, dashboardState);
                      }
                    },
                    icon: const Icon(
                      Icons.view_list_rounded,
                      color: Colors.white,
                    ))
              ],
              backgroundColor: Colors.indigoAccent,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    height: 55.0,
                    child: DropdownMenu(
                      inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0)),
                      expandedInsets:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      dropdownMenuEntries: dashboardState.dropdownCategory
                          .map(
                            (value) => DropdownMenuEntry(
                                value: value, label: value.name),
                          )
                          .toList(),
                      label: const Text("Siapa?"),
                      controller: dashboardState.categoryText,
                      onSelected: dashboardState.selectCategory,
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0)),
                      expandedInsets:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      dropdownMenuEntries: dashboardState.dropdownType
                          .map(
                            (value) => DropdownMenuEntry(
                                value: value, label: value.name),
                          )
                          .toList(),
                      label: const Text("Apa?"),
                      controller: dashboardState.typeText,
                      onSelected: dashboardState.selectType,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    height: 55.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_money_rounded,
                          color: Colors.black54,
                        ),
                        Container(
                          width: 1.0,
                          color: Colors.black54,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: dashboardState.nominal,
                            onChanged: dashboardState.nominalTyping,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    height: 55.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notes_rounded,
                          color: Colors.black54,
                        ),
                        Container(
                          width: 1.0,
                          color: Colors.black54,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: dashboardState.notes,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 32.0, left: 16.0, right: 16.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(width: 0.5, color: Colors.grey),
                      color: Colors.greenAccent[700],
                    ),
                    child: TextButton.icon(
                      onPressed: () => dashboardState.saveData(),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  showFilter(BuildContext context, DashboardState dashboardState) {
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    onPressed: () => dashboardState.closeFilterModal(),
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
                  expandedInsets: const EdgeInsets.symmetric(horizontal: 16.0),
                  dropdownMenuEntries: dashboardState.dropdownCategory
                      .map(
                        (value) =>
                            DropdownMenuEntry(value: value, label: value.name),
                      )
                      .toList(),
                  label: const Text("Siapa?"),
                  controller: dashboardState.categorySearch,
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
                  expandedInsets: const EdgeInsets.symmetric(horizontal: 16.0),
                  dropdownMenuEntries: dashboardState.dropdownMonth
                      .map(
                        (value) =>
                            DropdownMenuEntry(value: value, label: value.name),
                      )
                      .toList(),
                  label: const Text("Bulan?"),
                  controller: dashboardState.monthSearch,
                  onSelected: dashboardState.selectMonth,
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
                  expandedInsets: const EdgeInsets.symmetric(horizontal: 16.0),
                  dropdownMenuEntries: dashboardState.dropdownYear
                      .map(
                        (value) =>
                            DropdownMenuEntry(value: value, label: value),
                      )
                      .toList(),
                  label: const Text("Tahun?"),
                  controller: dashboardState.yearSearch,
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
                  onPressed: () => dashboardState.toList(),
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
