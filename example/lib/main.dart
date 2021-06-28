import 'package:flutter/material.dart';

import 'package:custom_paginated_data_table/custom_paginated_data_table.dart';
import 'package:custom_paginated_data_table/custom_data_table_source.dart';
import 'package:custom_paginated_data_table/custom_data_table.dart';

void main() async {
  runApp(MaterialApp(
    title: "Table Example",
    home: Scaffold(
      appBar: AppBar(
        title: Text("Custom Paginate DataTable Example"),
      ),
      body: CustomPaginateDataTableExample(),
    ),
  ));
}

class CustomPaginateDataTableExample extends StatefulWidget {
  const CustomPaginateDataTableExample({Key? key}) : super(key: key);

  @override
  _CustomPaginateDataTableExampleState createState() =>
      _CustomPaginateDataTableExampleState();
}

class _CustomPaginateDataTableExampleState
    extends State<CustomPaginateDataTableExample> {
  final int col = 40;
  final int row = 1000;

  @override
  Widget build(BuildContext context) {
    final source = DataTableSource(col: col, row: row);
    return CustomPaginatedDataTable(
      columns: List.generate(
          col,
          (index) => CustomDataColumn(
                label: Text("head $index"),
              )),
      onSort: (int a, int b, int column) {
        if (a % column != b % column)
          return a % column - b % column;
        else {
          return b - a;
        }
      },
      getColumnsWidth: (index) => 150,
      source: source,
      customColumnsIndex: [],
      height: 600,
      sortColumnIndexList: List.generate(20, (index) => index * 2 + 1),
      showColumnNumber: 5,
      availableRowsPerPage: [10, 20, 50, 100, 200, 500],
    );
  }
}

class DataTableSource extends CustomDataTableSource {
  final col;
  final row;
  DataTableSource({
    required this.col,
    required this.row,
  });

  @override
  CustomDataRow getRow(int index) {
    ValueNotifier<bool> selected = ValueNotifier<bool>(false);

    return CustomDataRow.byIndex(
      selected: selected,
      index: index,
      cells: List.generate(
        col,
        (columnIndex) => CustomDataCell(Text("col$columnIndex : row$index")),
      ),
      onSelectChanged: (bool? isSelect) {
        // if (index % 2 == 0)
        if (isSelect != null && isSelect != selected.value) {
          selected.value = isSelect;
          if (isSelect) {
            selectedRowCount++;
          } else {
            selectedRowCount--;
          }
        }
      },
    );
  }

  @override
  int get rowCount => row;

  @override
  bool get isRowCountApproximate => false;

  @override
  int selectedRowCount = 0;
}
